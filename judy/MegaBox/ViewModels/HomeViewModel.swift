import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    // 상단 탭
    enum TopTab: String, CaseIterable {
        case home = "홈"
        case event = "이벤트"
        case store = "스토어"
        case favoriteTheater = "선호극장"
    }

    // 하단 필터
    enum Segment: String, CaseIterable {
        case movieChart = "무비차트"
        case comingSoon  = "상영예정"
    }

    // UI 상태
    @Published var selectedTopTab: TopTab = .home
    @Published var selectedSegment: Segment = .movieChart

    // 데이터
    @Published var allMovies: [AppMovie] = []
    @Published var visibleMovies: [AppMovie] = []

    @Published var debugText: String = ""
    private var cancellables = Set<AnyCancellable>()

    // 초기화: 세그먼트 변경 시 리스트 갱신 + JSON 로드
    init() {
        $selectedSegment
            .removeDuplicates()
            .sink { [weak self] _ in self?.updateVisibleMovies() }
            .store(in: &cancellables)

        Task { await loadMovies() }
    }

    // JSON 로드 (MovieSchedule.json)
    func loadMovies() async {
        guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
            debugText = "❌ MovieSchedule.json을 찾지 못했습니다."
            print(debugText); return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(MovieScheduleResponseDTO.self, from: data)
            let mapped = decoded.toMoviesForList()   // [AppMovie]
            self.allMovies = mapped
            self.updateVisibleMovies()
            debugText = "✅ Home 로드 완료: \(mapped.count)편"
        } catch {
            debugText = "❌ 디코딩 실패: \(error)"
            print(debugText)
        }
    }

    // 세그먼트에 따라 화면에 노출할 리스트 구성
    private func updateVisibleMovies() {
        guard !allMovies.isEmpty else { visibleMovies = []; return }
        let today = Date()
        switch selectedSegment {
        case .movieChart:
            // 데모: 제목 오름차순
            visibleMovies = allMovies.sorted { $0.titleKo < $1.titleKo }

        case .comingSoon:
            // 가장 이른 상영일이 오늘 이후인 영화만
            let coming = allMovies.filter { earliestScheduleDate(of: $0).map { $0 > today } ?? false }
            visibleMovies = (coming.isEmpty ? allMovies : coming)
                .sorted { earliestScheduleDate(of: $0) ?? .distantFuture
                       < earliestScheduleDate(of: $1) ?? .distantFuture }
        }
    }

    private func earliestScheduleDate(of movie: AppMovie) -> Date? {
        movie.schedules.map(\.date).sorted().first
    }
}
