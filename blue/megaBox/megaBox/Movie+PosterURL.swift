//
//  Movie+PosterURL.swift
//  megaBox
//
//  Created by 은재 on 11/17/25.
//

import Foundation

private let TMDBImageBase = "https://image.tmdb.org/t/p/w500"

extension Movie {
    var posterURL: URL? {
        guard let path = posterName else { return nil }
        return URL(string: TMDBImageBase + path)
    }
}
