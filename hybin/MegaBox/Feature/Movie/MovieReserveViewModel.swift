//
//  MovieReserveViewModel.swift
//  MegaBox
//
//  Created by 전효빈 on 10/8/25.
//

import Foundation
import SwiftUI
import Combine

class MovieReserveViewModel: ObservableObject {
    
    @ObservationIgnored
    private let movieService = MovieService()
    
    private var calendarVM : CalendarViewModel = .init()
    
    //MARK: - 시트뷰
    @Published var searchText: String = ""
    @Published var debouncedText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    private func setupDebounce() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] newText in
                self?.debouncedText = newText
            }
            .store(in: &cancellables)
    }
    
    init(selectedMoive: MovieModel) {
        self.selectedMovie = selectedMoive
        
        self.movies = movieService.getMovies()
        
        setupDebounce()
    }
    
    //MARK: - 리저브 뷰
    @Published var movies: [MovieModel]
    
    let theaters : [String] = ["강남", "홍대", "신촌"]
    
    @Published var selectedTheater: String? = nil
    @Published var date: Date = Date()
    @Published var selectedMovie: MovieModel?
    
    @Published var canReserve: Bool = false
    
    
    
    func selectMovie(_ movie: MovieModel) {
        self.selectedMovie = movie
    }
    
    
    private let tempScheduleData: [TheaterSchedule] = [
        .init(theaterName: "강남", rooms: [
            .init(time: "11:30", endTime: "~13:58", remainingSeats: 109, totalSeats: 116, is2D: true, specialTheaterName: "크리클라이너 1관"),
            .init(time: "14:20", endTime: "~16:48", remainingSeats: 19, totalSeats: 116, is2D: true, specialTheaterName: "크리클라이너 1관"),
            .init(time: "17:05", endTime: "~19:28", remainingSeats: 1, totalSeats: 116, is2D: true, specialTheaterName: "크리클라이너 1관"),
            .init(time: "19:45", endTime: "~22:02", remainingSeats: 100, totalSeats: 116, is2D: true, specialTheaterName: "크리클라이너 1관"),
            .init(time: "22:20", endTime: "~00:04", remainingSeats: 116, totalSeats: 116, is2D: true, specialTheaterName: "크리클라이너 1관")
        ]),
        .init(theaterName: "홍대", rooms: [
            .init(time: "9:30", endTime: "~11:50", remainingSeats: 75, totalSeats: 116, is2D: true, specialTheaterName: "BTS관 (7층 1관 [Laser])"),
            .init(time: "12:00", endTime: "~14:26", remainingSeats: 102, totalSeats: 116, is2D: true, specialTheaterName: "BTS관 (7층 1관 [Laser])"),
            .init(time: "14:45", endTime: "~17:04", remainingSeats: 88, totalSeats: 116, is2D: true, specialTheaterName: "BTS관 (7층 1관 [Laser])"),
            .init(time: "11:30", endTime: "~13:58", remainingSeats: 34, totalSeats: 116, is2D: true, specialTheaterName: "BTS관 (9층 2관 [Laser])"),
            .init(time: "14:10", endTime: "~16:32", remainingSeats: 100, totalSeats: 116, is2D: true, specialTheaterName: "BTS관 (9층 2관 [Laser])"),
            .init(time: "16:50", endTime: "~19:00", remainingSeats: 13, totalSeats: 116, is2D: true, specialTheaterName: "BTS관 (9층 2관 [Laser])"),
            .init(time: "19:20", endTime: "~21:40", remainingSeats: 92, totalSeats: 116, is2D: true, specialTheaterName: "BTS관 (9층 2관 [Laser])")
        ]),
        // 신촌은 상영 정보가 없어야 하므로 빈 배열을 유지하거나 리스트에서 제외
    ]
    
    //선택 조건에 맞는 상영표 제공
    var filteredSchedules: [TheaterSchedule] {
        
        guard selectedMovie != nil, selectedTheater != nil, calendarVM.calendar.isDateInToday(calendarVM.selectedDate) else {
            return [] // 선택이 되어야 출력, 날짜는 오늘만
        }
        
        //선택된 극장에 따라 필터링
        return tempScheduleData.filter { schedule in
            schedule.theaterName == selectedTheater
        }
    }
    
    
}


