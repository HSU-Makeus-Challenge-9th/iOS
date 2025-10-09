import SwiftUI
import Combine

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
    let time: String
    let left: Int
    let total: Int
}

struct DayItem: Identifiable, Hashable, Equatable {
    let id = UUID()
    let date: Date
    var day: String { DateFormatter.cached("d").string(from: date) }
    var weekday: String { DateFormatter.cached("E").string(from: date) }
    var month: String { DateFormatter.cached("M").string(from: date) }
    var isToday: Bool { Calendar.current.isDateInToday(date) }
}

private extension DateFormatter {
    static func cached(_ format: String) -> DateFormatter {
        let f = DateFormatter()
        f.locale = .init(identifier: "ko_KR")
        f.dateFormat = format
        return f
    }
}

@MainActor
final class BookingViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var days: [DayItem] = BookingViewModel.makeWeek()
    @Published var showtimes: [Theater: [Showtime]] = [:]

    @Published var selectedMovie: Movie? = nil
    @Published var selectedTheaters: Set<Theater> = []
    @Published var selectedDay: DayItem? = nil

    @Published var canSelectTheater: Bool = false
    @Published var canSelectDate: Bool = false
    @Published var canShowRooms: Bool = false

    private var bag = Set<AnyCancellable>()

    init(initialMovie: Movie? = nil) {
        seedMovies()
        seedShowtimes()
        selectedMovie = initialMovie
        bind()
    }

    private func bind() {
        $selectedMovie
            .map { $0 != nil }
            .receive(on: DispatchQueue.main)
            .assign(to: \.canSelectTheater, on: self)
            .store(in: &bag)

        Publishers.CombineLatest($selectedMovie.map { $0 != nil },
                                 $selectedTheaters.map { !$0.isEmpty })
        .map { $0 && $1 }
        .receive(on: DispatchQueue.main)
        .assign(to: \.canSelectDate, on: self)
        .store(in: &bag)

        Publishers.CombineLatest3($selectedMovie.map { $0 != nil },
                                  $selectedTheaters.map { !$0.isEmpty },
                                  $selectedDay.map { $0 != nil })
        .map { $0 && $1 && $2 }
        .receive(on: DispatchQueue.main)
        .assign(to: \.canShowRooms, on: self)
        .store(in: &bag)
    }

    private func seedMovies() {
        movies = [
            Movie(title: "F1 더 무비",         audience: "", posterName: "p1", badge: "15"),
            Movie(title: "극장판 귀멸의 칼날",   audience: "", posterName: "p2", badge: "15"),
            Movie(title: "어쩔수가없다",        audience: "", posterName: "p3", badge: "15"),
            Movie(title: "얼굴",              audience: "", posterName: "p4", badge: "15"),
            Movie(title: "모노노케 히메",       audience: "", posterName: "p5", badge: "12"),
            Movie(title: "보스",              audience: "", posterName: "p6", badge: "15"),
            Movie(title: "야당",              audience: "", posterName: "p7", badge: "12"),
            Movie(title: "THE ROSES",        audience: "", posterName: "p8", badge: "15")
        ]
    }

    private static let gangnamTimes: [Showtime] = [
        .init(theater: .gangnam, screen: "크리클라이너 1관", time: "11:30", left: 109, total: 116),
        .init(theater: .gangnam, screen: "크리클라이너 1관", time: "14:20", left: 19,  total: 116),
        .init(theater: .gangnam, screen: "크리클라이너 1관", time: "17:05", left: 1,   total: 116),
        .init(theater: .gangnam, screen: "크리클라이너 1관", time: "19:45", left: 100, total: 116),
        .init(theater: .gangnam, screen: "크리클라이너 1관", time: "22:20", left: 116, total: 116)
    ]

    private static let hongdaeTimes: [Showtime] = [
        .init(theater: .hongdae, screen: "BTS관 (7층 1관 [Laser])", time: "09:30", left: 75,  total: 116),
        .init(theater: .hongdae, screen: "BTS관 (7층 1관 [Laser])", time: "12:00", left: 102, total: 116),
        .init(theater: .hongdae, screen: "BTS관 (7층 1관 [Laser])", time: "14:45", left: 88,  total: 116),
        .init(theater: .hongdae, screen: "BTS관 (9층 2관 [Laser])", time: "11:30", left: 34,  total: 116),
        .init(theater: .hongdae, screen: "BTS관 (9층 2관 [Laser])", time: "14:10", left: 100, total: 116),
        .init(theater: .hongdae, screen: "BTS관 (9층 2관 [Laser])", time: "16:50", left: 13,  total: 116),
        .init(theater: .hongdae, screen: "BTS관 (9층 2관 [Laser])", time: "19:20", left: 92,  total: 116)
    ]

    private func seedShowtimes() {
        showtimes[.gangnam] = Self.gangnamTimes
        showtimes[.hongdae] = Self.hongdaeTimes
        showtimes[.sinchon] = []
    }

    static func makeWeek(from base: Date = Date()) -> [DayItem] {
        (0..<7).compactMap { i in
            DayItem(date: Calendar.current.date(byAdding: .day, value: i, to: base)!)
        }
    }

    var isTodaySelected: Bool { selectedDay?.isToday == true }
}

// MARK: - BookingView
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
            MovieSearchSheet(allMovies: vm.movies) { picked in
                vm.selectedMovie = picked
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden) // 커스텀 핸들 사용
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
            if let badge = vm.selectedMovie?.badge, !badge.isEmpty {
                Text(badge)
                    .font(.system(size: 14, weight: .heavy))
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(badgeColor(badge))
                    )
                    .foregroundColor(.white)
            }
            Text(vm.selectedMovie?.title ?? "어쩔수가없다")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.black)

            Spacer()

            Button {
                showSearch = true
            } label: {
                Text("전체영화")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 12).padding(.vertical, 8)
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
                        .onTapGesture { vm.selectedMovie = m }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var theaterChips: some View {
        HStack(spacing: 8) {
            ForEach(Theater.allCases) { th in
                TheaterChipNew(title: th.rawValue, selected: vm.selectedTheaters.contains(th))
                    .onTapGesture {
                        guard vm.canSelectTheater else { return }
                        if vm.selectedTheaters.contains(th) { vm.selectedTheaters.remove(th) }
                        else { vm.selectedTheaters.insert(th) }
                    }
                    .opacity(vm.canSelectTheater ? 1 : 0.35)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    private var dayRow: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7),
            spacing: 0
        ) {
            ForEach(vm.days) { d in
                DayPill(day: d, selected: vm.selectedDay == d)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard vm.canSelectDate else { return }
                        vm.selectedDay = d
                    }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }

    private var showtimesList: some View {
        VStack(alignment: .leading, spacing: 36) {
            if vm.canShowRooms {
                let d = vm.selectedDay
                ForEach(Array(vm.selectedTheaters).sorted { $0.rawValue < $1.rawValue }, id: \.self) { th in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(th.rawValue)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)

                        if d?.isToday == true {
                            if let items = vm.showtimes[th], !items.isEmpty {
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

struct DayPill: View {
    let day: DayItem
    let selected: Bool

    var body: some View {
        let cal = Calendar.current
        let wd = cal.component(.weekday, from: day.date) // 1=일, 7=토
        let weekendColor: Color = (wd == 1) ? .red : ((wd == 7) ? .teal : .black)

        let tomorrow = cal.date(byAdding: .day, value: 1, to: Date())!
        let isTomorrow = cal.isDate(day.date, inSameDayAs: tomorrow)
        let subtitle = day.isToday ? "오늘" : (isTomorrow ? "내일" : day.weekday)

        Group {
            if selected {
                VStack(spacing: 4) {
                    Text("\(day.month).\(day.day)")
                        .font(.system(size: 13, weight: .bold))
                        .lineLimit(1).minimumScaleFactor(0.7).allowsTightening(true)
                    Text(subtitle)
                        .font(.system(size: 11, weight: .bold))
                        .lineLimit(1).minimumScaleFactor(0.7).allowsTightening(true)
                }
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color("purple03")))
            } else {
                VStack(spacing: 4) {
                    Text("\(day.day)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(weekendColor)
                        .lineLimit(1).minimumScaleFactor(0.7).allowsTightening(true)
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(Color("gray03"))
                        .lineLimit(1).minimumScaleFactor(0.7).allowsTightening(true)
                }
                .frame(height: 56)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct TheaterSection: View {
    let title: String
    let items: [Showtime]
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

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
                ForEach(items) { it in
                    ShowtimeCard(show: it)
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
        "14:10": "~16:32", "16:50": "~19:00", "19:20": "~21:40",
    ]
    var endText: String { endMap[show.time] ?? " " }

    var body: some View {
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
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("gray02"), lineWidth: 1))
    }
}

struct EmptyMessage: View {
    var body: some View {
        Text("선택한 극장에 상영시간표가 없습니다")
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
            if let name = movie.posterName, UIImage(named: name) != nil {
                Image(name).resizable().scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(Image(systemName: "photo"))
            }
        }
        .frame(width: 62, height: 89)
        .clipped()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(selected ? Color("purple03") : .clear, lineWidth: 5)
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
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(selected ? Color("purple03") : Color("gray01"))
            )
            .foregroundColor(selected ? .white : Color("gray05"))
    }
}

// MARK: - 검색 시트
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
                return all.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
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
        _vm = StateObject(wrappedValue: MovieSearchViewModel(allMovies: allMovies))
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
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                .padding(.horizontal, 16)
                .padding(.top, 12)

                // 결과 그리드
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 36) {
                        ForEach(vm.results) { m in
                            VStack(spacing: 8) {
                                if let name = m.posterName, UIImage(named: name) != nil {
                                    Image(name)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 95, height: 135)
                                        .clipped() // 라운드 0
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 95, height: 135)
                                        .overlay(Image(systemName: "photo"))
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
            .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }
}


// 선택 코너만 둥글게
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

