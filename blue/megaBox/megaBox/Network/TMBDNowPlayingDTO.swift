//
//  TMBDNowPlayingDTO.swift
//  megaBox
//
//  Created by 은재 on 11/17/25.
//

import Foundation

// ✔ TMDB "Now Playing" 응답 루트 (이름 충돌 방지)
struct TMDBNowPlayingDTO: Decodable {
    let page: Int
    let results: [TMDBMovieBriefDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// ✔ TMDB 영화 요약 정보 (기존 MovieDTO와 이름 다르게!)
struct TMDBMovieBriefDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
