//
//  MovieService.swift
//  MegaBox
//
//  Created by 전효빈 on 10/22/25.
//

import Foundation
import SwiftUI

@Observable
class MovieService {
    
    func getMovies() -> [MovieModel] {
        
        let movieModel: [MovieModel] = [
            .init(title: "모노노케 히메", posterImage: .init(.모노노케히메), audience: 30, bookranking: 5),
            .init(title: "어쩔수가 없다", posterImage: .init(.어쩔수가없다), audience: 25, bookranking: 5),
            .init(title: "귀멸의 칼날", posterImage: .init(.무한성), audience: 15, bookranking: 5),
            .init(title: "F1", posterImage: .init(.f1), audience: 155, bookranking: 5),
            .init(title: "보스", posterImage: .init(.보스)  , audience: 12, bookranking: 5),
        ]
        
        return movieModel
    }
    
    // API 통신을 위한 함수
    
    func fetchMoviesFromServer() async -> [MovieModel] {
        
        try? await Task.sleep(for: .seconds(1))
        
        return getMovies()
    }
}


