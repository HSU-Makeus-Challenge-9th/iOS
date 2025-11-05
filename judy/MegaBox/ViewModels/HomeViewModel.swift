import Foundation
import Combine

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

    @Published var selectedTopTab: TopTab = .home      // 기본 홈
    @Published var selectedSegment: Segment = .movieChart

    // 직접 넣은 예시 영화
    @Published var movies: [Movie] = [
        Movie(titleKo: "F1 더 무비",
              titleEn: "F1: The Movie",
              posterHome: "F1main",
              posterDetail: "F1detail",
              audience: "누적 1,234,567명")
    ]

    var visibleMovies: [Movie] {
        selectedSegment == .movieChart ? movies : []
    }
}
