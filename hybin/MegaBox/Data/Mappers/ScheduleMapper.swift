//
//  ScheduleMapper.swift
//  MegaBox
//
//  Created by 전효빈 on 10/27/25.
//

import Foundation


//struct MovieModel: Identifiable {
//    let id = UUID() <-- m-001 이런식으로 Json 형태에 맞춰야함.
//
//    let title : String
//    
//    let posterImage : Image
//    
//    let audience : Int
//    
//    let bookranking : Int
//    
//}
//
//struct ScreeningTime: Identifiable {
//    let id = UUID()
//    let time: String // "11:30"
//    let endTime: String // "~13:58"
//    let remainingSeats: Int // 109
//    let totalSeats: Int // 116
//    let is2D: Bool
//    let specialTheaterName: String? // "크리클라이너 1관"
//}
//
//
//struct TheaterSchedule: Identifiable {
//    let id = UUID()
//    let theaterName: String // "강남" 또는 "홍대"
//    let rooms: [ScreeningTime] // 해당 극장의 모든 상영 시간표
//}


struct ScheduleMapper {
    
    static func toDomain
    (from dto:ScheduleResponseDTO, for movieID: String, on date: String)
    -> [TheaterSchedule] {
        
        guard let movieDTO = dto.data.movies.first(where: { $0.id == movieID }) else {return []}
        
        guard let scheduleDTO = movieDTO.schedules.first(where: { $0.date == date }) else {return []}
        
        let theaterSchedules = scheduleDTO.areas.map{areaDTO in
            
            let rooms: [ScreeningTime] = areaDTO.items.flatMap { itemDTO in
                
                return itemDTO.showtimes.map{ showtimeDTO in
                    
                    return ScreeningTime(
                        time: showtimeDTO.start,
                        endTime: "~" + showtimeDTO.end,
                        remainingSeats: showtimeDTO.available,
                        totalSeats: showtimeDTO.total,
                        is2D: itemDTO.format.uppercased() == "2D",
                        specialTheaterName: itemDTO.auditorium
                    )
                }
            }
            
            return TheaterSchedule(
                theaterName: areaDTO.area, rooms: rooms
            )
        }
        return theaterSchedules
    }
}
