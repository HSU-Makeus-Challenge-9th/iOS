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
    
    static func mapToDomain(areas: [AreaDTO]) -> [TheaterSchedule] {
            
            // 1. DTO -> Domain Model
            return areas.map { areaDTO in
                
                // 2. [AreaDTO] 안의 [ItemDTO]를 -> [ScreeningTime]으로 변환
                //    (ItemDTO 1개가 방(auditorium)이고, 그 안에 상영시간(showtimes)이 여러 개 있음)
                let screeningTimes = areaDTO.items.flatMap { itemDTO in
                    // 3. 'flatMap'을 사용해 ShowTimeDTOs -> ScreeningTime 배열로 "펼침"
                    itemDTO.showtimes.map { showtimeDTO in
                        ScreeningTime(
                            time: showtimeDTO.start,
                            endTime: showtimeDTO.end,
                            remainingSeats: showtimeDTO.available,
                            totalSeats: showtimeDTO.total,
                            is2D: (itemDTO.format == "2D"), // (format으로 2D 여부 추정)
                            specialTheaterName: itemDTO.auditorium // (auditorium을 방 이름으로 사용)
                        )
                    }
                }
                
                return TheaterSchedule(
                    theaterName: areaDTO.area,
                    rooms: screeningTimes
                )
            }
        }
    }
