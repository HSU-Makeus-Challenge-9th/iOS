//
//  MovieScheduleDTO.swift
//  megaBox
//
//  Created by 은재 on 10/28/25.
//

import SwiftUI

struct APIResponse: Codable {
    let status: String
    let message: String
    let data: ShowtimesData
}

struct ShowtimesData: Codable {
    let movies: [MovieDTO]
}

struct MovieDTO: Codable {
    let id: String
    let title: String
    let ageRating: String
    let schedules: [ScheduleDTO]

    enum CodingKeys: String, CodingKey {
        case id, title, schedules
        case ageRating = "age_rating"
    }
}

struct ScheduleDTO: Codable {
    let date: String              // e.g. "2025-09-22"
    let areas: [AreaDTO]
}

struct AreaDTO: Codable {
    let area: String              // 지역명 (e.g. "강남", "홍대")
    let items: [AreaItemDTO]
}

struct AreaItemDTO: Codable {
    let auditorium: String        // 상영관 정보
    let format: String            // 포맷 (e.g. "2D", "IMAX", "4DX", "Dolby")
    let showtimes: [ShowtimeDTO]
}

struct ShowtimeDTO: Codable {
    let start: String             // e.g. "11:30"
    let end: String               // e.g. "13:58"
    let available: Int            // 잔여 좌석
    let total: Int                // 총 좌석
}
