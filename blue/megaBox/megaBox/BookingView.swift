import SwiftUI
import Combine
import Foundation

enum Theater: String, CaseIterable, Identifiable, Hashable {
    case gangnam = "강남"
    case hongdae = "홍대"
    case sinchon = "신촌"

    var id: String { rawValue }
}

struct Showtime: Identifiable, Hashable {
    let id = UUID()
    let theater: Theater
    let screen: String
    let time: String   // "HH:mm"
    let left: Int
    let total: Int
}

struct DayItem: Identifiable, Hashable, Equatable {
    let id = UUID()
    let date: Date

    var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
    var monthNumber: Int {
        Calendar.current.component(.month, from: date)
    }
    var weekdayLabel: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "E"
        return f.string(from: date)
    }
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
}

@MainActor
final class BookingViewModel: ObservableObject {

    @Published var movies: [Movie] = []
    @Published var days: [DayItem] = BookingViewModel.makeWeek()

    @Published var selectedMovie: Movie? = nil
    @Published var selectedTheaters: Set<Theater> = []
    @Published var selectedDay: DayItem? = nil

    @Published var canSelectTheater: Bool = false
    @Published var canSelectDate: Bool = false
    @Published var canShowRooms: Bool = false

    private var domainMovies: [MovieDomain] = []
    private var bag = Set<AnyCancellable>()

    init(initialMovie: Movie? = nil) {
        Task { await loadMoviesFromBundle() }
        self.selectedMovie = initialMovie
        bind()
    }

    // JSON -> Domain -> UI 변환
    private func loadMoviesFromBundle() async {
        do {
            guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
                print("❌ MovieSchedule.json not found")
                return
            }

            let data: Data = try await Task.detached {
                try Data(contentsOf: url)
            }.value

            let decoder = JSONDecoder()
            let dto = try decoder.decode(APIResponse.self, from: data)
            let dm = try dto.toDomainMovies()

            self.domainMovies = dm
            applyInitialUI(from: dm)

        } catch {
            print("JSON decode/map error:", error)
        }
    }

    // domainMovies -> 화면에서 쓸 Movie 배열 생성
    // 여기서 posterName을 ["amovie","bmovie","c2movie"] 순서대로 매핑
    private func applyInitialUI(from dms: [MovieDomain]) {

        let posterNames = ["amovie", "c2movie", "bmovie"]

        self.movies = dms.enumerated().map { (idx, dom) in
            let poster = idx < posterNames.count ? posterNames[idx] : nil
            return Movie(
                title: dom.title,
                audience: "",
                posterName: poster,
                badge: dom.ageRating
            )
        }

        if selectedMovie == nil {
            selectedMovie = self.movies.first
        }

        refreshAfterMovieChange()
        refreshAfterTheaterChange()
        refreshAfterDateChange()
    }

    // 현재 선택된 Movie를 MovieDomain으로 찾아오는 헬퍼
    private func currentDomainMovie() -> MovieDomain? {
        guard let sel = selectedMovie else { return nil }

        if let exact = domainMovies.first(where: { $0.title == sel.title }) {
            return exact
        }
        if let loose = domainMovies.first(where: { dm in
            dm.title.contains(sel.title) || sel.title.contains(dm.title)
        }) {
            return loose
        }
        return nil
    }

    // 선택된 영화에서 가능한 극장들
    var availableTheatersForSelectedMovie: [Theater] {
        guard let movie = currentDomainMovie() else { return [] }

        let areaNames = movie.schedules.flatMap { sched in
            sched.areas.map { $0.name }
        }

        var found = Set<Theater>()
        for t in Theater.allCases {
            for raw in areaNames {
                if raw.contains(t.rawValue) || t.rawValue.contains(raw) {
                    found.insert(t)
                }
            }
        }
        return Array(found)
    }

    // 선택된 영화 + 선택된 극장 조합에서 가능한 날짜들
    var availableDaysForSelectedMovieAndTheater: [Date] {
        guard let movie = currentDomainMovie() else { return [] }

        if selectedTheaters.isEmpty {
            return movie.schedules.map { $0.date }
        }

        let selNames = selectedTheaters.map { $0.rawValue }
        var validDates = Set<Date>()

        for sched in movie.schedules {
            let areaNames = sched.areas.map { $0.name }
            let match = areaNames.contains { area in
                selNames.contains { sel in
                    area.contains(sel) || sel.contains(area)
                }
            }
            if match {
                validDates.insert(sched.date)
            }
        }
        return Array(validDates)
    }

    // 실제 상영표 (극장별 -> Showtime 배열)
    var filteredShowtimesByTheater: [Theater: [Showtime]] {
        guard
            let movie = currentDomainMovie(),
            let day = selectedDay?.date
        else { return [:] }

        let schedulesForThatDay = movie.schedules.filter {
            Calendar.current.isDate($0.date, inSameDayAs: day)
        }

        let hm: DateFormatter = {
            let f = DateFormatter()
            f.locale = Locale(identifier: "ko_KR")
            f.dateFormat = "HH:mm"
            return f
        }()

        var result: [Theater: [Showtime]] = [:]

        for sched in schedulesForThatDay {
            for area in sched.areas {
                guard let th = theaterEnum(forAreaName: area.name) else { continue }

                if !selectedTheaters.isEmpty && !selectedTheaters.contains(th) {
                    continue
                }

                for item in area.items {
                    let shows = item.showtimes.map { st in
                        Showtime(
                            theater: th,
                            screen: item.auditorium,
                            time: hm.string(from: st.start),
                            left: st.available,
                            total: st.total
                        )
                    }
                    result[th, default: []].append(contentsOf: shows)
                }
            }
        }

        for (th, arr) in result {
            result[th] = arr.sorted {
                if $0.time == $1.time {
                    return $0.screen < $1.screen
                } else {
                    return $0.time < $1.time
                }
            }
        }

        return result
    }

    private func theaterEnum(forAreaName name: String) -> Theater? {
        for t in Theater.allCases {
            if name.contains(t.rawValue) || t.rawValue.contains(name) {
                return t
            }
        }
        return nil
    }

    // 바인딩: 선택 변화에 따라 상태 갱신
    private func bind() {
        $selectedMovie
            .sink { [weak self] _ in
                guard let self else { return }
                self.refreshAfterMovieChange()
                self.refreshAfterTheaterChange()
                self.refreshAfterDateChange()
            }
            .store(in: &bag)

        $selectedTheaters
            .sink { [weak self] _ in
                guard let self else { return }
                self.refreshAfterTheaterChange()
                self.refreshAfterDateChange()
            }
            .store(in: &bag)

        $selectedDay
            .sink { [weak self] _ in
                guard let self else { return }
                self.refreshAfterDateChange()
            }
            .store(in: &bag)
    }

    // 영화 바뀌면: 가능한 극장 계산해서 selectedTheaters 맞춰주고 canSelectTheater 갱신
    private func refreshAfterMovieChange() {
        let allowed = availableTheatersForSelectedMovie

        canSelectTheater = (selectedMovie != nil && !allowed.isEmpty)

        selectedTheaters = selectedTheaters.filter { allowed.contains($0) }

        if selectedTheaters.isEmpty, let first = allowed.first {
            selectedTheaters.insert(first)
        }
    }

    // 극장 바뀌면: 가능한 날짜 제한하고 canSelectDate, selectedDay 갱신
    private func refreshAfterTheaterChange() {
        let allowedDates = availableDaysForSelectedMovieAndTheater

        canSelectDate = (
            selectedMovie != nil &&
            !selectedTheaters.isEmpty &&
            !allowedDates.isEmpty
        )

        if let selDay = selectedDay {
            let stillValid = allowedDates.contains {
                Calendar.current.isDate($0, inSameDayAs: selDay.date)
            }
            if !stillValid {
                selectedDay = nil
            }
        }

        if selectedDay == nil,
           let firstDate = allowedDates.sorted(by: { $0 < $1 }).first,
           let dayItem = days.first(where: {
               Calendar.current.isDate($0.date, inSameDayAs: firstDate)
           }) {
            selectedDay = dayItem
        }
    }

    // 날짜 바뀌면: 이제 상영관/시간표 보여줄 수 있는지 결정
    private func refreshAfterDateChange() {
        canShowRooms = (
            selectedMovie != nil &&
            !selectedTheaters.isEmpty &&
            selectedDay != nil
        )
    }

    // 앞으로 7일 DayItem 생성
    static func makeWeek(from base: Date = Date()) -> [DayItem] {
        (0..<7).compactMap { i in
            let d = Calendar.current.date(byAdding: .day, value: i, to: base)!
            return DayItem(date: d)
        }
    }

    var isTodaySelected: Bool {
        selectedDay?.isToday == true
    }
}


// MARK: - View

struct BookingView: View {
    @StateObject private var vm: BookingViewModel
    @State private var showSearch = false

    init(initialMovie: Movie? = nil) {
        _vm = StateObject(wrappedValue: BookingViewModel(initialMovie: initialMovie))
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    movieSectionHeader
                    movieRow
                    theaterChips
                    dayRow
                    showtimesList
                }
                .padding(.vertical, 16)
            }
            .background(Color.white)
        }
        .background(Color("purple03").ignoresSafeArea(edges: .top))
        .sheet(isPresented: $showSearch) {
            MovieSearchSheet(
                allMovies: vm.movies,
                onPick: { picked in
                    vm.selectedMovie = picked
                }
            )
        }
    }

    private var header: some View {
        ZStack {
            Text("영화별 예매")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color("purple03"))
    }

    private var movieSectionHeader: some View {
        HStack(spacing: 8) {
            if
                let badge = vm.selectedMovie?.badge,
                !badge.isEmpty
            {
                Text(badge)
                    .font(.system(size: 14, weight: .heavy))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(badgeColor(badge))
                    )
                    .foregroundColor(.white)
            }

            Text(vm.selectedMovie?.title ?? "")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.black)

            Spacer()

            Button {
                showSearch = true
            } label: {
                Text("전체영화")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("gray02"), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
    }

    private func badgeColor(_ badge: String) -> Color {
        switch badge {
        case "12": return Color("mint01")
        case "15": return .orange
        default:   return Color("gray05")
        }
    }

    private var movieRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(vm.movies) { m in
                    MovieCard(movie: m, selected: vm.selectedMovie == m)
                        .onTapGesture {
                            vm.selectedMovie = m
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var theaterChips: some View {
        HStack(spacing: 8) {
            ForEach(Theater.allCases) { th in
                let isEnabled = vm.availableTheatersForSelectedMovie.contains(th)
                TheaterChipNew(title: th.rawValue,
                               selected: vm.selectedTheaters.contains(th))
                    .onTapGesture {
                        guard vm.canSelectTheater, isEnabled else { return }
                        if vm.selectedTheaters.contains(th) {
                            vm.selectedTheaters.remove(th)
                        } else {
                            vm.selectedTheaters.insert(th)
                        }
                    }
                    .opacity(vm.canSelectTheater && isEnabled ? 1 : 0.3)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    private var dayRow: some View {
        let allowedDates = vm.availableDaysForSelectedMovieAndTheater

        return LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7),
            spacing: 0
        ) {
            ForEach(vm.days) { d in
                let isAllowed = allowedDates.contains {
                    Calendar.current.isDate($0, inSameDayAs: d.date)
                }

                DayPill(day: d,
                        selected: vm.selectedDay == d)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard vm.canSelectDate, isAllowed else { return }
                        vm.selectedDay = d
                    }
                    .opacity(vm.canSelectDate && isAllowed ? 1 : 0.3)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }

    private var showtimesList: some View {
        VStack(alignment: .leading, spacing: 36) {
            if vm.canShowRooms {
                let chosenTheaters = Array(vm.selectedTheaters).sorted { $0.rawValue < $1.rawValue }

                ForEach(chosenTheaters, id: \.self) { th in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(th.rawValue)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)

                        if let items = vm.filteredShowtimesByTheater[th],
                           !items.isEmpty {
                            let grouped = Dictionary(grouping: items, by: { $0.screen })
                            let orderedScreens = grouped.keys.sorted()

                            ForEach(orderedScreens, id: \.self) { screen in
                                if let list = grouped[screen] {
                                    TheaterSection(title: screen, items: list)
                                        .padding(.top, 8)
                                }
                            }
                        } else {
                            EmptyMessage()
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.top, 8)
    }
}


// MARK: - Subviews

struct DayPill: View {
    let day: DayItem
    let selected: Bool

    var body: some View {
        let cal = Calendar.current
        let wd = cal.component(.weekday, from: day.date) // 1=일, 7=토
        let weekendColor: Color = (wd == 1) ? .red : ((wd == 7) ? .teal : .black)

        let tomorrow = cal.date(byAdding: .day, value: 1, to: Date())!
        let isTomorrow = cal.isDate(day.date, inSameDayAs: tomorrow)
        let subtitle = day.isToday ? "오늘" : (isTomorrow ? "내일" : weekdayKorean(day.weekdayLabel))

        Group {
            if selected {
                VStack(spacing: 4) {
                    Text("\(day.monthNumber).\(day.dayNumber)")
                        .font(.system(size: 13, weight: .bold))
                    Text(subtitle)
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("purple03"))
                )
            } else {
                VStack(spacing: 4) {
                    Text("\(day.dayNumber)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(weekendColor)
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(Color("gray03"))
                }
                .frame(height: 56)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func weekdayKorean(_ w: String) -> String {
        // "월", "화", ... 같은 포맷이 이미 들어오면 그대로 써도 됨
        return w
    }
}

struct TheaterSection: View {
    let title: String
    let items: [Showtime]

    private let columns: [GridItem] =
        Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Text("2D")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("gray05"))
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(items) { show in
                    ShowtimeCard(show: show)
                }
            }
        }
    }
}

struct ShowtimeCard: View {
    let show: Showtime

    private let endMap: [String: String] = [
        "11:30": "~13:58", "14:20": "~16:48", "17:05": "~19:28",
        "19:45": "~22:02", "22:20": "~00:04",
        "09:30": "~11:50", "12:00": "~14:26", "14:45": "~17:04",
        "14:10": "~16:32", "16:50": "~19:00", "19:20": "~21:40"
    ]

    var body: some View {
        let endText = endMap[show.time] ?? " "

        VStack(alignment: .leading, spacing: 8) {
            Text(show.time)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)

            Text(endText)
                .font(.system(size: 12))
                .foregroundColor(Color("gray05"))

            HStack(spacing: 2) {
                Text(String(show.left))
                    .foregroundColor(Color("purple03"))
                    .font(.system(size: 14, weight: .semibold))
                Text("/ \(show.total)")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
            }
        }
        .padding(.vertical, 19)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .frame(height: 90)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("gray02"), lineWidth: 1)
        )
    }
}

struct EmptyMessage: View {
    var body: some View {
        Text("선택한 조건에 맞는 상영시간표가 없습니다")
            .font(.system(size: 12))
            .foregroundColor(.secondary)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MovieCard: View {
    let movie: Movie
    let selected: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let asset = movie.posterName,
               UIImage(named: asset) != nil {
                Image(asset)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.black)
                    )
            }
        }
        .frame(width: 62, height: 89)
        .clipped()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(selected ? Color("purple03") : .clear,
                        lineWidth: 5)
        )
        .cornerRadius(10)
    }
}

struct TheaterChipNew: View {
    let title: String
    let selected: Bool

    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(selected ? Color("purple03") : Color("gray01"))
            )
            .foregroundColor(selected ? .white : Color("gray05"))
    }
}


// MARK: - 영화 검색 시트

final class MovieSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var results: [Movie] = []

    private let all: [Movie]
    private var bag = Set<AnyCancellable>()

    init(allMovies: [Movie]) {
        self.all = allMovies
        results = allMovies

        $query
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [all] q in
                let trimmed = q.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return all }
                return all.filter {
                    $0.title.localizedCaseInsensitiveContains(trimmed)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.results, on: self)
            .store(in: &bag)
    }
}

struct MovieSearchSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: MovieSearchViewModel
    let onPick: (Movie) -> Void

    init(allMovies: [Movie], onPick: @escaping (Movie) -> Void) {
        _vm = StateObject(
            wrappedValue: MovieSearchViewModel(allMovies: allMovies)
        )
        self.onPick = onPick
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: 52, height: 5)
                    .padding(.top, 8)

                Text("영화 선택")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.top, 6)

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color("gray05"))
                    TextField("Search", text: $vm.query)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Spacer(minLength: 0)
                    Image(systemName: "mic.fill")
                        .foregroundColor(Color("gray05"))
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal, 16)
                .padding(.top, 12)

                ScrollView {
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.flexible(), spacing: 12),
                            count: 3
                        ),
                        spacing: 36
                    ) {
                        ForEach(vm.results) { m in
                            VStack(spacing: 8) {
                                if let asset = m.posterName,
                                   UIImage(named: asset) != nil {
                                    Image(asset)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 95, height: 135)
                                        .clipped()
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 95, height: 135)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .foregroundColor(.black)
                                        )
                                }

                                Text(m.title)
                                    .font(.system(size: 12))
                                    .lineLimit(1)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onPick(m)
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 28)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .clipShape(
                RoundedCorner(radius: 16, corners: [.topLeft, .topRight])
            )
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = [.allCorners]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    BookingView()
}

