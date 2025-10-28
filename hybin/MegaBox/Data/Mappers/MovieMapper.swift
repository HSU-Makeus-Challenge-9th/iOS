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
        let tempPosterImage = Image("movie_placeholder")
        let tempBookRanking:Int  = 0
        let tempAudience:Int  = 0
        
        return MovieModel(
            id: idFromDTO,
            title: titleFromDTO,
            posterImage: tempPosterImage,
            audience: tempAudience,
            bookRanking: tempBookRanking
        )
    }
    
    
    static func toDomain(from dtos: [MovieScheduleDTO]) -> [MovieModel] {
        return dtos.map{toDomain(from: $0)}
    }// 반복 호출을 위한 함수
}
