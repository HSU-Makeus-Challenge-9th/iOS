//
//  MovieMapper.swift
//  MegaBox
//
//  Created by 전효빈 on 10/28/25.
//

import Foundation
import SwiftUI

struct MovieMapper {
    
    static func toDomain(from dto: MovieScheduleDTO) -> MovieModel {
        
        let idFromDTO:String = dto.id
        let titleFromDTO = dto.title
        
        //---MARK: Json에 없는 데이터
        let tempPosterImage = assetName(for: dto.title)
        let tempBookRanking:Int  = 0
        let tempAudience:Int  = 0

        
        return MovieModel(
            id: idFromDTO,
            title: titleFromDTO,
            posterImage: Image(tempPosterImage),
            audience: tempAudience,
            bookRanking: tempBookRanking
        )
    }
    
    private static func assetName(for title: String) -> String {
            switch title {
            case "어쩔수가없다":
                return "어쩔수가없다" // Assets에 "어쩔수가없다" 이미지가 있음
            case "귀멸의 칼날: 무한성":
                return "무한성" // Assets에 "무한성" 이미지가 있음
             case "F1 더 무비":
                 return "f1" // (만약 "F1" 에셋이 있다면)
            default:
 
                return "umcLogo"
            }
        }
    
    static func toDomain(from dtos: [MovieScheduleDTO]) -> [MovieModel] {
        return dtos.map{toDomain(from: $0)}
    }// 반복 호출을 위한 함수
}
