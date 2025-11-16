//
//  totalDTO.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/20/25.
//

import Foundation

struct MovieSchedule {
    let movies: [MovieDomain]
}

struct MovieDomain {
    let id: String
    let title: String
    let ageRating: String
    let schedules: [Schedule]
}

struct Schedule {
    let date: Date?
    let areas: [Area]
}

struct Area {
    let name: String
    let items: [Item]
}

struct Item {
    let auditorium: String
    let format: String
    let showtimes: [ShowTime]
}

struct ShowTime {
    let start: Date?
    let end: Date?
    let available: Int
    let total: Int
}


struct MovieScheduleResponseDTO: Codable {
    let status: String
    let message: String
    let data: MovieScheduleDTO
}

struct MovieScheduleDTO: Codable {
    let movies: [MovieDTO]
}


struct MovieDTO: Codable {
    let id: String
    let title: String
    let ageRating: String
    let schedules: [ScheduleDTO]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case ageRating = "age_rating"
        case schedules
    }
}

struct ScheduleDTO: Codable {
    let date: String
    let areas: [AreaDTO]
}

struct AreaDTO: Codable {
    let area: String
    let items: [ItemDTO]
}

struct ItemDTO: Codable {
    let auditorium: String
    let format: String
    let showtimes: [ShowtimeDTO]
}

struct ShowtimeDTO: Codable {
    let start: String
    let end: String
    let available: Int
    let total: Int
}


extension DateFormatter {
    static let scheduleDateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            f.locale = Locale(identifier: "ko_KR")
            f.timeZone = TimeZone(secondsFromGMT: 9*3600)
            return f
        }()

        static let dateTimeFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd HH:mm"
            f.locale = Locale(identifier: "ko_KR")
            f.timeZone = TimeZone(secondsFromGMT: 9*3600)
            return f
        }()
}

extension MovieScheduleResponseDTO {
    func toDomain() -> MovieSchedule {
        return data.toDomain() ?? MovieSchedule(movies: [])
    }
}
extension MovieScheduleDTO {
    func toDomain() -> MovieSchedule {
        let movieDomains = movies.map { $0.toDomain() } ?? []
        return MovieSchedule(movies: movieDomains)
    }
}

extension ScheduleDTO {
    func toDomain() -> Schedule {
        let parsedDate = DateFormatter.scheduleDateFormatter.date(from: date)
        let areaDomains = areas.map { $0.toDomain(scheduleDateString: date) }
        return Schedule(date: parsedDate, areas: areaDomains)
    }
}
extension MovieDTO {
    func toDomain() -> MovieDomain {
        return MovieDomain(
            id: id,
            title: title,
            ageRating: ageRating,
            schedules: schedules.map { $0.toDomain() }
        )
    }
}

extension AreaDTO {
    func toDomain(scheduleDateString: String?) -> Area {
        return Area(
            name: area,
            items: items.map { $0.toDomain(scheduleDateString: scheduleDateString) }
        )
    }
}
extension ItemDTO {
    func toDomain(scheduleDateString: String?) -> Item {
        return Item(
            auditorium: auditorium,
            format: format,
            showtimes: showtimes.map { $0.toDomain(scheduleDateString: scheduleDateString) }
        )
    }
}

extension ShowtimeDTO {
    func toDomain(scheduleDateString: String?) -> ShowTime {
       func makeDate(fromDateString dateStr: String?, timeStr: String?) -> Date? {
            guard let dateStr = dateStr,
                  let timeStr = timeStr,
                  !dateStr.isEmpty,
                  !timeStr.isEmpty else { return nil }
            let combined = "\(dateStr) \(timeStr)"
            return DateFormatter.dateTimeFormatter.date(from: combined)
        }

        let startDate = makeDate(fromDateString: scheduleDateString, timeStr: start)
        let endDate = makeDate(fromDateString: scheduleDateString, timeStr: end)

        return ShowTime(
            start: startDate,
            end: endDate,
            available: available ?? 0,
            total: total ?? 0
        )
    }
}

