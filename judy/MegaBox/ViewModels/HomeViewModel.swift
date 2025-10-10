import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    enum Segment: String, CaseIterable {
        case movieChart = "무비차트"
        case comingSoon  = "상영예정"
    }

    @Published var selectedSegment: Segment = .movieChart

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
