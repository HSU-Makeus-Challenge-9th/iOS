//
//  MovieScheduleDTOs.swift
//  MegaBox
//
//  Created by 전효빈 on 10/27/25.
//

import Foundation

struct ScheduleResponseDTO: Codable {
    let status:String
    let message:String
    let data:MovieDataDTO
}

struct MovieDataDTO: Codable {
    let movies: [MovieScheduleDTO]
}

struct MovieScheduleDTO: Codable {
    let id : String
    let title : String
    let ageRating : String
    let schedules : [ScheduleDTO]
    
    enum CodingKeys: String, CodingKey {
        case id, title, schedules
        case ageRating = "age_rating"
    }
}

struct ScheduleDTO: Codable {
    let date: String
    let areas : [AreaDTO]
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
