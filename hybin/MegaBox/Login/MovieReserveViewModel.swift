//
//  MovieReserveViewModel.swift
//  MegaBox
//
//  Created by 전효빈 on 10/8/25.
//

import Foundation
import SwiftUI
import Combine

class MovieReserveViewModel: ObservableObject {
    
    private var homeVM : HomeViewModel
    
    var movies: [MovieModel] {
        homeVM.movieModel
    }
    
    @Published var theater: String = ""
    @Published var date: Date = Date()
    
    @Published var selectedMovie: MovieModel?
    
    @Published var canReserve: Bool = false
    
    init(homeVM: HomeViewModel, selectedMovie: MovieModel? = nil) {
        self.homeVM = homeVM
        self.selectedMovie = selectedMovie
    }
    
    func selectMovie(_ movie: MovieModel) {
        self.selectedMovie = movie
    }
}
