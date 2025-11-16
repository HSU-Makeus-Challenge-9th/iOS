//
//  HomeViewModel.swift
//  MegaBox
//
//  Created by 전효빈 on 9/30/25.
//

import Foundation
import SwiftUI
import Combine

@Observable
class HomeViewModel {
    
    var movieCharts: [MovieCardModel] = []
    
    var isLoading: Bool = false
    
    private let movieService = MovieAPIService.shared
    
    @MainActor
    func fetchNowPlayingMovies() async {
        self.isLoading = true
        
        
        do {
            let dto = try await movieService.provider.asyncRequest(
                .nowPlaying(language: "ko-KR", page: 1, region: "KR"), responseType: MovieResponseDTO.self)
            
            let imageBaseURL = "https://image.tmdb.org/t/p/w500"
            let backdropBaseURL = "https://image.tmdb.org/t/p/w780"
            
            self.movieCharts = dto.results.map { result in
                MovieCardModel(
                    id: result.id,
                    movieTitle : result.title,
                    moviePoster: "\(imageBaseURL)\(result.poster_path ?? "")",
                    releaseDate: result.release_date ?? "N/A",
                    ageLimit: "15",
                    bookRanking: 0.0,
                    totalAudience: "10만",
                    
                    //디테일뷰 용
                    backdropPath: "\(backdropBaseURL)\(result.backdrop_path ?? "")",
                    originalTitle: result.original_title ?? "N/A",
                    overview: result.overview ?? "N/A"
                )
            }
        }catch {
            print("TMDB API 호출 실패")
        
        }
        self.isLoading = false
    }

    
}
