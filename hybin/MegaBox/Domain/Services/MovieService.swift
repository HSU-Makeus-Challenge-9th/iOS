//
//  MovieService.swift
//  MegaBox
//
//  Created by 전효빈 on 10/22/25.
//

import Foundation
import SwiftUI

enum ApiError: Error {
    case fileNotFound
    case decodingError(Error)
    case serverError(String)
}

@Observable
class MovieService {
    
//    func getMovies() -> [MovieModel] {
//        
//        let movieModel: [MovieModel] = [
//            .init(title: "모노노케 히메", posterImage: .init(.모노노케히메), audience: 30, bookRanking: 5),
//            .init(title: "어쩔수가 없다", posterImage: .init(.어쩔수가없다), audience: 25, bookRanking: 5),
//            .init(title: "귀멸의 칼날", posterImage: .init(.무한성), audience: 15, bookRanking: 5),
//            .init(title: "F1", posterImage: .init(.f1), audience: 155, bookRanking: 5),
//            .init(title: "보스", posterImage: .init(.보스)  , audience: 12, bookRanking: 5),
//        ]
//        
//        return movieModel
//    }
    
    // API 통신을 위한 함수
    
//    func fetchMoviesFromServer() async -> [MovieModel] {
//        
//        try? await Task.sleep(for: .seconds(1))
//        
//        return getMovies()
//    }
    
    func fetchMovies() async throws -> [MovieModel] {
        
        let responseDTO = try await decodeLocalJSON() //JSON 파일 읽기
        
        guard responseDTO.status == "success" else {
            throw ApiError.serverError(responseDTO.message)
        }
        
        let movieDTOs = responseDTO.data.movies
        
        let models = MovieMapper.toDomain(from: movieDTOs)
        
        return models
    }
    
    func fetchSchedules(for movieID: String, on date: Date) async throws
    -> [TheaterSchedule] {
        
        let responseDTO = try await decodeLocalJSON()
        
        guard responseDTO.status == "success" else {
            throw ApiError.serverError(responseDTO.message)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let schedules = ScheduleMapper.toDomain(
            from: responseDTO, for: movieID, on: dateString
        )
        return schedules
    }
    
    private func decodeLocalJSON() async throws -> ScheduleResponseDTO {
        
        //url이 안맞으면 에러
        guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
            print("MovieSchedule.json 파일을 찾을 수 없습니다")
            throw ApiError.fileNotFound
        }
        
        //데이터가 없으면 에러
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch{
            print("JSON 파일 로드 실패: \(error.localizedDescription)")
            throw ApiError.decodingError(error)
        }
        
        //구조체와 매핑이 안되면 에러
        let decoder = JSONDecoder()
        do {
            let responseDTO = try decoder.decode(ScheduleResponseDTO.self, from: data)
            return responseDTO
        } catch {
            print("JSON 디코딩 실패: \(error.localizedDescription)")
            throw ApiError.decodingError(error)
        }
    }
}
