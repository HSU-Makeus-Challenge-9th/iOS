import Foundation

struct MovieDomain: Identifiable, Hashable {
    let id: String
    let title: String
    let ageRating: String
    let schedules: [ScheduleDomain]
}

struct ScheduleDomain: Hashable {
    let date: Date
    let areas: [AreaDomain]
}

struct AreaDomain: Hashable {
    let name: String
    let items: [AuditoriumItemDomain]
}

struct AuditoriumItemDomain: Hashable {
    let auditorium: String
    let format: String
    let showtimes: [ShowtimeDomain]
}

struct ShowtimeDomain: Hashable {
    let start: Date
    let end: Date
    let available: Int
    let total: Int
}

enum MapperError: Error {
    case invalidDate(String)
    case invalidTime(String)
}

enum MapFmt {
    static var cal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.locale = Locale(identifier: "ko_KR")
        c.timeZone = TimeZone(secondsFromGMT: 9 * 3600)!
        return c
    }()

    static let day: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.calendar = MapFmt.cal
        f.timeZone = MapFmt.cal.timeZone
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}

extension APIResponse {
    func toDomainMovies() throws -> [MovieDomain] {
        try data.movies.map { try $0.toDomain() }
    }
}

extension MovieDTO {
    func toDomain() throws -> MovieDomain {
        let scheduleDomains = try schedules.map { try $0.toDomain() }
        return MovieDomain(
            id: id,
            title: title,
            ageRating: ageRating,
            schedules: scheduleDomains
        )
    }
}

extension ScheduleDTO {
    func toDomain() throws -> ScheduleDomain {
        guard let d = MapFmt.day.date(from: date) else {
            throw MapperError.invalidDate(date)
        }
        let areaDomains = try areas.map { try $0.toDomain(baseDate: d) }
        return ScheduleDomain(date: d, areas: areaDomains)
    }
}

extension AreaDTO {
    func toDomain(baseDate: Date) throws -> AreaDomain {
        let itemDomains = try items.map { try $0.toDomain(baseDate: baseDate) }
        return AreaDomain(name: area, items: itemDomains)
    }
}

extension AreaItemDTO {
    func toDomain(baseDate: Date) throws -> AuditoriumItemDomain {
        let sds = try showtimes.map { try $0.toDomain(baseDate: baseDate) }
        return AuditoriumItemDomain(auditorium: auditorium, format: format, showtimes: sds)
    }
}

extension ShowtimeDTO {
    func toDomain(baseDate: Date) throws -> ShowtimeDomain {

        func combine(_ time: String) throws -> Date {
            let parts = time.split(separator: ":")
            guard parts.count == 2,
                  let hour = Int(parts[0]), let minute = Int(parts[1]) else {
                throw MapperError.invalidTime(time)
            }

            var comps = MapFmt.cal.dateComponents([.year, .month, .day], from: baseDate)
            comps.hour = hour
            comps.minute = minute
            comps.second = 0
            comps.calendar = MapFmt.cal
            comps.timeZone = MapFmt.cal.timeZone

            guard let dt = MapFmt.cal.date(from: comps) else {
                throw MapperError.invalidTime(time)
            }
            return dt
        }

        let startDate = try combine(start)
        var endDate   = try combine(end)

        // 자정 넘어가는 케이스 처리 (필요 없으면 제거)
        if endDate < startDate, let plus1 = MapFmt.cal.date(byAdding: .day, value: 1, to: endDate) {
            endDate = plus1
        }

        return ShowtimeDomain(
            start: startDate,
            end: endDate,
            available: available,
            total: total
        )
    }
}
