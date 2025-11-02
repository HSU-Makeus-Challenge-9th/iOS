//
//  MovieService.swift
//  MegaBox
//
//  Created by 전효빈 on 10/22/25.
//

import Foundation
import SwiftUI


enum ApiError: Error, LocalizedError {
    case jsonFileNotFound
    case decodingError(DecodingError)
    case serverError(String)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .jsonFileNotFound:
            return "JSON 파일을 찾을 수 없습니다."
        case .decodingError(let error):
            return "JSON 파싱 실패: \(error.localizedDescription)"
        case .serverError(let message):
            return "서버 에러: \(message)"
        case .unknown(let error):
            return "알 수 없는 에러: \(error.localizedDescription)"
        }
    }
}


@Observable
class MovieService {

    //---MARK: HomeView용
    @MainActor
    func fetchMovies() async throws -> [MovieModel] {
        
        let responseDTO = try await decodeLocalJSON() //JSON 파일 읽기
        
        guard responseDTO.status == "success" else {
            throw ApiError.serverError(responseDTO.message)
        }
        
        let movieDTOs = responseDTO.data.movies
        
        let models = MovieMapper.toDomain(from: movieDTOs)
        
        return models
    }
    
    //---MARK: MovieReserveView용
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
        
        //url찾기
        guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
            print("MovieSchedule.json 파일을 찾을 수 없습니다")
            throw ApiError.jsonFileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            let responseDTO = try decoder.decode(ScheduleResponseDTO.self, from: data)
            
            return responseDTO
        } catch let decodingError as DecodingError {
            print("JSON 디코딩 에러")
            throw ApiError.decodingError(decodingError)
        } catch {
            print("알 수 없는 에러")
            throw ApiError.unknown(error)
        }
    }
    
 
}
