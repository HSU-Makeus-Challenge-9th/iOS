//
//  MovieResponseDTO.swift
//  MegaBox
//
//  Created by 전효빈 on 11/16/25.
//

import Foundation

struct MovieResponseDTO: Decodable, Sendable {
    let results: [MovieResultDTO]
    let page: Int
}

struct MovieResultDTO: Decodable, Sendable {
    let id: Int
    let title:String
    let original_title:String?
    let overview:String?
    let poster_path:String?
    let backdrop_path:String?
    let release_date:String?
}
