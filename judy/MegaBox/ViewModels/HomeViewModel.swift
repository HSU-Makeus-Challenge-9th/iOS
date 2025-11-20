import Foundation
import SwiftUI
import Combine
import Moya

@MainActor
final class HomeViewModel: ObservableObject {

    enum TopTab: String, CaseIterable {
        case home = "홈"
        case event = "이벤트"
        case store = "스토어"
        case favoriteTheater = "선호극장"
    }

    enum Segment: String, CaseIterable {
        case movieChart = "무비차트"
        case comingSoon  = "상영예정"
    }

    @Published var selectedTopTab: TopTab = .home
    @Published var selectedSegment: Segment = .movieChart

    @Published var allMovies: [AppMovie] = []
    @Published var visibleMovies: [AppMovie] = []
    @Published var debugText: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let tmdbProvider = MoyaProvider<TMDBTarget>()

    init() {
        $selectedSegment
            .removeDuplicates()
            .sink { [weak self] _ in self?.updateVisibleMovies() }
            .store(in: &cancellables)
    }

    func fetchNowPlaying() async {
        do {
            let response = try await tmdbProvider.asyncRequest(.nowPlaying(page: 1))
            let decoded = try JSONDecoder().decode(TMDBNowPlayingResponse.self, from: response.data)

            let mapped: [AppMovie] = decoded.results.map { dto in
                AppMovie(
                    id: String(dto.id),
                    titleKo: dto.title,
                    titleEn: dto.originalTitle,
                    overview: dto.overview,
                    releaseDate: dto.releaseDate,
                    posterHome: "",
                    posterDetail: "",
                    posterURL: URL(string: "https://image.tmdb.org/t/p/w500\(dto.posterPath ?? "")"),
                    backdropURL: URL(string: "https://image.tmdb.org/t/p/w780\(dto.backdropPath ?? "")"),
                    audience: "12",
                    schedules: []
                )
            }

            self.allMovies = mapped
            self.updateVisibleMovies()
            debugText = "✅ TMDB에서 \(mapped.count)편 로드"

        } catch {
            debugText = "❌ TMDB 요청 실패: \(error.localizedDescription)"
            self.allMovies = []
            self.visibleMovies = []
        }
    }

    private func updateVisibleMovies() {
        guard !allMovies.isEmpty else { visibleMovies = []; return }
        let today = Date()
        switch selectedSegment {
        case .movieChart:
            visibleMovies = allMovies.sorted { $0.titleKo < $1.titleKo }
        case .comingSoon:
            let coming = allMovies.filter { earliestScheduleDate(of: $0).map { $0 > today } ?? false }
            visibleMovies = (coming.isEmpty ? allMovies : coming)
                .sorted {
                    earliestScheduleDate(of: $0) ?? .distantFuture
                    < earliestScheduleDate(of: $1) ?? .distantFuture
                }
        }
    }

    private func earliestScheduleDate(of movie: AppMovie) -> Date? {
        movie.schedules.map(\.date).sorted().first
    }
}
