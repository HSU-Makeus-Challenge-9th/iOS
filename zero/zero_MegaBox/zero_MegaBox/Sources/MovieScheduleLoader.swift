//
//  MovieScheduleLoader.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/1/25.
//

import Foundation

enum MovieScheduleLoader {
    
    static func load(from fileName: String) async -> MovieScheduleDTO? {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("\(fileName).json 파일을 찾을 수 없습니다.")
            return nil
        }
        
        do {
            // 비동기적으로 JSON 데이터 읽기
            let data = try await Task.detached(priority: .background) {
                return try Data(contentsOf: fileURL)
            }.value
            
            let decoder = JSONDecoder()
            
            let decodedResponse = try decoder.decode(MovieScheduleResponseDTO.self, from: data)
            
            print("JSON 디코딩 성공: \(fileName).json (\(decodedResponse.data.movies.count)개 영화)")
            
            return decodedResponse.data
            
        } catch let decodingError as DecodingError {
            switch decodingError {
            case .dataCorrupted(let context):
                print("데이터 손상: \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                print("키 없음: \(key.stringValue) - \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("타입 불일치: \(type) - \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("값 없음: \(type) - \(context.debugDescription)")
            @unknown default:
                print("알 수 없는 디코딩 에러")
            }
            return nil
            
        } catch {
            print("파일 읽기 실패: \(error.localizedDescription)")
            return nil
        }
    }
}
