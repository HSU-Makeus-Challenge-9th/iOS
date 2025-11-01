//
//  MovieModel.swift
//  MegaBox
//
//  Created by 전효빈 on 10/2/25.
//

import Foundation
import SwiftUI


struct MovieModel: Identifiable {
    let id = UUID()
    
    let title : String
    
    let posterImage : Image
    
    let audience : Int
    
    let bookranking : Int
    
}

struct ScreeningTime: Identifiable {
    let id = UUID()
    let time: String // "11:30"
    let endTime: String // "~13:58"
    let remainingSeats: Int // 109
    let totalSeats: Int // 116
    let is2D: Bool
    let specialTheaterName: String? // "크리클라이너 1관"
}


struct TheaterSchedule: Identifiable {
    let id = UUID()
    let theaterName: String // "강남" 또는 "홍대"
    let rooms: [ScreeningTime] // 해당 극장의 모든 상영 시간표
}
