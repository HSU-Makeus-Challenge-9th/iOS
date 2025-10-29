import Foundation
import Combine

@MainActor
final class BookingViewModel: ObservableObject {

    // 영화 목록
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

    // 선택 상태
    @Published var selectedMovie: Movie? = nil
    @Published var selectedTheater: String? = nil
    @Published var selectedDate: Date? = nil
    @Published var showSearchSheet: Bool = false

    // 디버그 표기용
    @Published var debugText: String = ""

    // JSON에서 가져온 상영정보
    /// 원본
    private var schedulesByTitle: [String: [BookingSchedule]] = [:]
    /// 정규화 버전
    private var schedulesByTitleNormalized: [String: [BookingSchedule]] = [:]

    // JSON 제목과 로컬 제목 매핑
    private let titleAlias: [String: String] = [
        "귀멸의 칼날: 무한성편": "귀멸의 칼날: 무한성"
    ]

    // 파생 목록
    var theaters: [String] {
        guard let localTitle = selectedMovie?.titleKo else { return [] }
        let key = lookupKey(forLocalTitle: localTitle)
        guard let schedules = schedulesByTitle[key] ?? schedulesByTitleNormalized[key] else { return [] }
        let names = schedules.flatMap { $0.areas.map(\.name) }
        return Array(Set(names)).sorted()
    }

    var availableDates: [Date] {
        guard let localTitle = selectedMovie?.titleKo else { return [] }
        let key = lookupKey(forLocalTitle: localTitle)
        guard let schedules = schedulesByTitle[key] ?? schedulesByTitleNormalized[key] else { return [] }
        return schedules.map(\.date).sorted()
    }

    var filteredAuditoriums: [BookingAuditorium] {
        guard
            let localTitle = selectedMovie?.titleKo,
            let theater = selectedTheater,
            let date = selectedDate
        else { return [] }

        let key = lookupKey(forLocalTitle: localTitle)
        guard let schedules = schedulesByTitle[key] ?? schedulesByTitleNormalized[key] else { return [] }

        let cal = Calendar.current
        guard
            let schedule = schedules.first(where: { cal.isDate($0.date, inSameDayAs: date) }),
            let area = schedule.areas.first(where: { $0.name == theater })
        else { return [] }

        return area.items
    }

    var showtimeGroups: [(hall: String, format: String, shows: [BookingShowtime])] {
        filteredAuditoriums.map { ($0.name, $0.format, $0.showtimes) }
    }

    var hasShowtime: Bool { selectedMovie != nil && selectedTheater != nil && selectedDate != nil }

    // 초기화
    init() {
        Task { await loadSchedules() }
    }

    // 액션
    func loadSchedules() async {
        guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
            debugText = "❌ MovieSchedule.json 파일을 번들에서 찾지 못했습니다. (Target membership/파일명 확인)"
            print(debugText)
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(MovieScheduleResponseDTO.self, from: data)

            // 원본 맵
            let rawMap = decoded.toSchedulesByTitle()
            self.schedulesByTitle = rawMap

            // 정규화 맵
            var norm: [String: [BookingSchedule]] = [:]
            for (title, sched) in rawMap {
                norm[normalize(title)] = sched
            }
            self.schedulesByTitleNormalized = norm

            debugText = """
            스케줄 로드: 원본키 \(rawMap.keys.count)개
            원본키: \(Array(rawMap.keys))
            정규화키: \(Array(norm.keys))
            """
            print(debugText)

            // 초기 선택: 스케줄이 실제로 존재하는 첫 영화로 자동 설정
            if selectedMovie == nil {
                if let firstWithSchedule = movies.first(where: { hasSchedule(forLocalTitle: $0.titleKo) }) {
                    selectMovie(firstWithSchedule)
                } else {
                    selectedMovie = movies.first
                }
            }

            // 선택된 영화 기준으로 날짜/극장 자동 셋팅(비어있을 때만)
            if selectedDate == nil { selectedDate = availableDates.first }
            if selectedTheater == nil { selectedTheater = theaters.first }

        } catch {
            debugText = "❌ 스케줄 디코딩 실패: \(error)"
            print(debugText)
        }
    }

    func selectMovie(_ movie: Movie) {
        selectedMovie = movie
        selectedDate = availableDates.first
        selectedTheater = theaters.first
        // 선택 즉시 디버그 갱신
        let key = lookupKey(forLocalTitle: movie.titleKo)
        let has = schedulesByTitle[key] != nil || schedulesByTitleNormalized[key] != nil
        print("🎬 선택: \(movie.titleKo) → 키 \(key) / 스케줄 존재: \(has)")
    }

    // 유틸
    /// 로컬 제목을 JSON 키로 변환 (별칭 → 정규화까지)
    private func lookupKey(forLocalTitle local: String) -> String {
        let jsonLike = titleAlias[local] ?? local
        let normalized = normalize(jsonLike)
        // 우선 원본키 존재 여부 확인
        if schedulesByTitle[jsonLike] != nil { return jsonLike }
        // 없으면 정규화 키를 사용
        return normalized
    }

    /// 해당 로컬 제목이 스케줄을 갖는지 여부
    private func hasSchedule(forLocalTitle local: String) -> Bool {
        let key = lookupKey(forLocalTitle: local)
        return schedulesByTitle[key] != nil || schedulesByTitleNormalized[key] != nil
    }

    /// 제목 정규화
    private func normalize(_ s: String) -> String {
        let lowered = s.lowercased()
        // 공백/구두점/대괄호 등 제거
        let pattern = "[\\s\\p{Punct}\\p{Symbols}]"
        let replaced = lowered.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        return replaced
    }
}
