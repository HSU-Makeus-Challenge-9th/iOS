import Foundation
import Combine
import SwiftUI

@MainActor
final class BookingViewModel: ObservableObject {

    // MARK: Published
    @Published var movies: [AppMovie] = []
    @Published var selectedMovie: AppMovie? = nil
    @Published var selectedTheater: String? = nil
    @Published var selectedDate: Date? = nil
    @Published var debugText: String = ""
    @Published var showSearchSheet: Bool = false

    private var cancellables = Set<AnyCancellable>()

    // MARK: Derived
    var theaters: [String] {
        guard let m = selectedMovie else { return [] }
        let all = m.schedules.flatMap { $0.areas.map(\.name) }
        return Array(Set(all)).sorted()
    }

    var availableDates: [Date] {
        selectedMovie?.schedules.map(\.date).sorted() ?? []
    }

    var filteredAuditoriums: [BookingAuditorium] {
        guard
            let movie = selectedMovie,
            let theater = selectedTheater,
            let date = selectedDate
        else { return [] }
        let cal = Calendar.current
        guard
            let schedule = movie.schedules.first(where: { cal.isDate($0.date, inSameDayAs: date) }),
            let area = schedule.areas.first(where: { $0.name == theater })
        else { return [] }
        return area.items
    }

    var showtimeGroups: [(hall: String, format: String, shows: [BookingShowtime])] {
        filteredAuditoriums.map { ($0.name, $0.format, $0.showtimes) }
    }

    var hasShowtime: Bool { selectedMovie != nil && selectedTheater != nil && selectedDate != nil }

    // MARK: Convenience Bindings (Picker 등에 사용)
    func bindingSelectedMovieID() -> Binding<String> {
        Binding<String>(
            get: { [weak self] in
                guard let self = self else { return "" }
                return self.selectedMovie?.id ?? self.movies.first?.id ?? ""
            },
            set: { [weak self] newID in
                self?.selectedMovie = self?.movies.first(where: { $0.id == newID })
            }
        )
    }
    func bindingSelectedDate() -> Binding<Date> {
        Binding<Date>(
            get: { [weak self] in
                guard let self = self else { return Date() }
                return self.selectedDate ?? self.availableDates.first ?? Date()
            },
            set: { [weak self] newDate in self?.selectedDate = newDate }
        )
    }
    func bindingSelectedTheater() -> Binding<String> {
        Binding<String>(
            get: { [weak self] in
                guard let self = self else { return "" }
                return self.selectedTheater ?? self.theaters.first ?? ""
            },
            set: { [weak self] newTheater in self?.selectedTheater = newTheater }
        )
    }

    // MARK: Init
    init() {
        $selectedMovie
            .removeDuplicates { $0?.id == $1?.id }
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.selectedDate == nil || !(self.availableDates.contains(self.selectedDate!)) {
                    self.selectedDate = self.availableDates.first
                }
                if self.selectedTheater == nil || !(self.theaters.contains(self.selectedTheater!)) {
                    self.selectedTheater = self.theaters.first
                }
            }
            .store(in: &cancellables)

        Task { await loadSchedules() }
    }

    // MARK: Actions
    func loadSchedules() async {
        guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
            debugText = "❌ MovieSchedule.json 파일을 번들에서 찾지 못했습니다."
            print(debugText); return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(MovieScheduleResponseDTO.self, from: data)
            let mapped = decoded.toMoviesForList()
            self.movies = mapped
            if selectedMovie == nil { selectedMovie = movies.first }
        } catch {
            debugText = "❌ 디코딩 실패: \(error)"
            print(debugText)
        }
    }
}
