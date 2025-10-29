import Foundation

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
    let date: String                // "yyyy-MM-dd"
    let areas: [AreaDTO]
}

struct AreaDTO: Codable {
    let area: String                // 지역명 (강남/홍대 등)
    let items: [ItemDTO]
}

struct ItemDTO: Codable {
    let auditorium: String          // 상영관 이름
    let format: String              // 2D/IMAX/4DX 등
    let showtimes: [ShowtimeDTO]
}

struct ShowtimeDTO: Codable {
    let start: String
    let end: String
    let available: Int
    let total: Int
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

// Mapper 준비
private let ymdFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "ko_KR")
    f.timeZone = TimeZone(secondsFromGMT: 0)
    f.dateFormat = "yyyy-MM-dd"
    return f
}()

// 상영정보로 변환
extension ScheduleDTO {
    func toBooking() -> BookingSchedule {
        let d = ymdFormatter.date(from: date) ?? Date()
        return BookingSchedule(date: d, areas: areas.map { $0.toBooking() })
    }
}

extension AreaDTO {
    func toBooking() -> BookingArea {
        BookingArea(name: area, items: items.map { $0.toBooking() })
    }
}

extension ItemDTO {
    func toBooking() -> BookingAuditorium {
        BookingAuditorium(
            name: auditorium,
            format: format,
            showtimes: showtimes.map { $0.toBooking() }
        )
    }
}

extension ShowtimeDTO {
    func toBooking() -> BookingShowtime {
        BookingShowtime(start: start, end: end, available: available, total: total)
    }
}

// 기존 Movie 로 변환 + 상영정보 맵 생성
extension MovieScheduleResponseDTO {
    
    ///  기존 프로젝트의 Movie 생성자를 사용
    func toMoviesForList() -> [Movie] {
        data.movies.map { dto in
            Movie(
                titleKo: dto.title,
                titleEn: dto.title,
                posterHome: mapPoster(id: dto.id),  // 에셋 이름 매핑
                posterDetail: mapPoster(id: dto.id),
                audience: dto.age_rating
            )
        }
    }

    /// 상영정보 맵: 제목(ko) -> [BookingSchedule]
    func toSchedulesByTitle() -> [String: [BookingSchedule]] {
        var map: [String: [BookingSchedule]] = [:]
        for m in data.movies {
            map[m.title] = m.schedules.map { $0.toBooking() }
        }
        return map
    }

    /// 필요 시 포스터 에셋 이름 매핑
    private func mapPoster(id: String) -> String {
        switch id {
        case "m-001": return "poster-m-001"
        case "m-002": return "poster-m-002"
        case "m-003": return "poster-m-003"
        default: return "poster-default"
        }
    }
}
