import Foundation
import Combine

@MainActor
final class BookingViewModel: ObservableObject {
    // 영화 리스트
    @Published var movies: [Movie] = [
        Movie(titleKo: "F1 더 무비", titleEn: "F1 The Movie", posterHome: "F1main", posterDetail: "F1main", audience: "12"),
        Movie(titleKo: "귀멸의 칼날: 무한성편", titleEn: "Demon Slayer", posterHome: "movie1", posterDetail: "movie1", audience: "15"),
        Movie(titleKo: "어쩔수가없다", titleEn: "No Choice", posterHome: "movie2", posterDetail: "movie2", audience: "15"),
        Movie(titleKo: "얼굴", titleEn: "Face", posterHome: "movie3", posterDetail: "movie3", audience: "12"),
        Movie(titleKo: "모노노케 히메", titleEn: "Princess Mononoke", posterHome: "movie4", posterDetail: "movie4", audience: "12"),
        Movie(titleKo: "보스", titleEn: "The Boss", posterHome: "movie5", posterDetail: "movie5", audience: "12"),
        Movie(titleKo: "야당", titleEn: "Harang", posterHome: "movie6", posterDetail: "movie6", audience: "12"),
        Movie(titleKo: "The Roses", titleEn: "The Roses", posterHome: "movie7", posterDetail: "movie7", audience: "15")
    ]
    
    @Published var selectedMovie: Movie? = nil
    @Published var selectedTheater: String? = nil
    @Published var selectedDate: Date? = nil
    
    @Published var showSearchSheet: Bool = false
    
    // 극장 버튼
    let theaters = ["강남", "홍대", "신촌"]
    
    // 날짜 리스트
    var weekDates: [Date] {
        let today = Date()
        return (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: today) }
    }
    
    // 상영관 표시 로직
    var hasShowtime: Bool {
        selectedMovie != nil && selectedTheater != nil && selectedDate != nil
    }
}
