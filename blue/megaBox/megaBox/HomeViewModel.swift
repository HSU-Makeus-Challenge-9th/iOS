import SwiftUI
import Moya

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var details: [MovieDetail] = []
    @Published var articles: [Article] = []

    private let tmdb = MoyaProvider<TMDBAPI>()

    /// 홈 상단 "무비차트"에 쓸 지금 상영중 영화 목록 불러오기
    func fetchNowPlaying() async {
        do {
            print("✅ TMDB now_playing 요청 시작")

            let res = try await tmdb.request(.nowPlaying(page: 1))
            print("✅ statusCode =", res.statusCode)

            let decoder = JSONDecoder()
            // dates, page, results, total_pages, total_results 구조
            let dto = try decoder.decode(NowPlayingResponseDTO.self, from: res.data)

            print("✅ 디코딩 성공, results 개수:", dto.results.count)

            // 1) 카드에 쓰는 Movie 배열
            self.movies = dto.results.map { item in
                item.toUIMovie()
            }

            // 2) 상세 화면에 쓸 MovieDetail 배열
            self.details = dto.results.map { item in
                MovieDetail(
                    title: item.title,
                    englishTitle: item.title,
                    // 포스터는 TMDB path 를 그대로 넘겨두고,
                    // MovieDetailView 안에서 KFImage(URL(string: base + path)) 로 처리해도 됨
                    posterName: item.posterPath ?? "",
                    description: item.overview
                )
            }

            // 3) 하단 기사 섹션 더미 데이터 (필요하면 수정/삭제 가능)
            if articles.isEmpty {
                articles = [
                    Article(
                        title: "메가박스 오늘의 추천작",
                        subtitle: "지금 극장에서 만날 수 있는 인기 영화들을 모았어요.",
                        thumbnailName: "dmovie"
                    ),
                    Article(
                        title: "F1 더 무비 비하인드",
                        subtitle: "서킷 밖에서 벌어진 진짜 드라마",
                        thumbnailName: nil
                    )
                ]
            }

        } catch {
            print("❌ TMDB now_playing 호출/디코딩 실패:", error)
        }
    }
}

