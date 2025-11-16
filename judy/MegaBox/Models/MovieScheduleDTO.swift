import Foundation

// MARK: - DTOs (JSON)
struct MovieScheduleResponseDTO: Codable {
    let status: String
    let message: String
    let data: MovieScheduleDataDTO
}

struct MovieScheduleDataDTO: Codable {
    let movies: [MovieDTO]
}

struct MovieDTO: Codable, Identifiable {
    let id: String
    let title: String
    let age_rating: String
    let schedules: [ScheduleDTO]
}

struct ScheduleDTO: Codable {
    let date: String // "yyyy-MM-dd"
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

// MARK: - App Model
struct AppMovie: Identifiable, Equatable {
    let id: String
    let titleKo: String
    let titleEn: String
    let posterHome: String
    let posterDetail: String
    let audience: String
    let schedules: [BookingSchedule]
}

// Booking Domain
struct BookingSchedule: Equatable {
    let date: Date
    let areas: [BookingArea]
}

struct BookingArea: Equatable {
    let name: String
    let items: [BookingAuditorium]
}

struct BookingAuditorium: Equatable {
    let name: String
    let format: String
    let showtimes: [BookingShowtime]
}

struct BookingShowtime: Equatable, Identifiable {
    var id: String { "\(start)-\(end)-\(available)-\(total)" }
    let start: String
    let end: String
    let available: Int
    let total: Int
}

// MARK: - Mapper 준비
private let ymdFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "ko_KR")
    f.timeZone = TimeZone(secondsFromGMT: 9 * 3600) // KST
    f.dateFormat = "yyyy-MM-dd"
    return f
}()

extension ScheduleDTO {
    func toBooking() -> BookingSchedule {
        BookingSchedule(
            date: ymdFormatter.date(from: date) ?? Date(),
            areas: areas.map { $0.toBooking() }
        )
    }
}
extension AreaDTO {
    func toBooking() -> BookingArea {
        BookingArea(name: area, items: items.map { $0.toBooking() })
    }
}
extension ItemDTO {
    func toBooking() -> BookingAuditorium {
        BookingAuditorium(name: auditorium, format: format, showtimes: showtimes.map { $0.toBooking() })
    }
}
extension ShowtimeDTO {
    func toBooking() -> BookingShowtime {
        BookingShowtime(start: start, end: end, available: available, total: total)
    }
}

// MARK: - DTO → App Model
extension MovieScheduleResponseDTO {

    private func mapPoster(id: String) -> String {
        switch id {
        case "m-001": return "poster-m-001"
        case "m-002": return "poster-m-002"
        case "m-003": return "poster-m-003"
        default:      return "poster-default"
        }
    }

    // ViewModel에서 바로 사용할 리스트
    func toMoviesForList() -> [AppMovie] {
        data.movies.map { dto in
            AppMovie(
                id: dto.id,
                titleKo: dto.title,
                titleEn: dto.title,
                posterHome: mapPoster(id: dto.id),
                posterDetail: mapPoster(id: dto.id),
                audience: dto.age_rating,
                schedules: dto.schedules.map { $0.toBooking() }
            )
        }
    }
}
