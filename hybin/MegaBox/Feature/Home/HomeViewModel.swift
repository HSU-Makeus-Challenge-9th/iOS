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
    
    var movieModel: [MovieModel] = []
    
    @ObservationIgnored // UI 로직이 아니니 무시하게 끔.. Observable은 class 내부를 다 감시하니까..
    private let movieService =  MovieService()
    
    @MainActor //메인 쓰레드에 뜨게끔,, @Observable에서  .receive(on: DispatchQueue.main)과 같은 역할
    func loadMoives() async {
        self.movieModel = await movieService.fetchMoviesFromServer()
    }
    
    
}
