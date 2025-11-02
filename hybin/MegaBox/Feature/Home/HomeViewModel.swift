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
    
    var errorMessage: String? = nil
    
    @MainActor //메인 쓰레드에 뜨게끔,, @Observable에서  .receive(on: DispatchQueue.main)과 같은 역할
    func loadMovies() async {
        do{
            let movies = try await movieService.fetchMovies()
            
            self.movieModel = movies
            self.errorMessage = nil
        } catch let error as ApiError {
            switch error {
            case .jsonFileNotFound:
                self.errorMessage = "파일을 찾을 수 없습니다."
            case .decodingError:
                self.errorMessage = "데이터 형식이 잘못되었습니다."
            case .serverError:
                self.errorMessage = "서버 오류: \(error.localizedDescription)"
            case .unknown:
                self.errorMessage = "알 수 없는 오류가 발생했습니다."
            }
            self.movieModel = [] //실패시 빈배열로 초기화
        } catch {
            self .errorMessage = "알 수 없는 오류가 발생했습니다."
            self .movieModel = []
        }
    }
    
}
