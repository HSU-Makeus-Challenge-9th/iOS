//
//  MovieViewModel.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/2/25.
//

import Foundation
import Combine

//@Observable
class MovieViewModel: ObservableObject {
    @Published var selectedMovieModel: MovieModel? = nil
    @Published var selectedDate: Date? = nil
    @Published var selectedTheaterName: String = ""
    
    @Published var isTheaterSelectable: Bool = false
    @Published var isDaySelectable: Bool = false

    var showScreeningInfo: Bool {
        selectedMovieModel != nil &&
        !selectedTheaterName.isEmpty &&
        selectedDate != nil &&
        !filteredShowtimes.isEmpty
    }
    
    @Published var screeningMessage: String = "선택한 극장에 상영시간표가 없습니다"
    @Published var selectedCinemaType: String = ""
        
    
    @Published var query: String = ""
    @Published var results: [MovieModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var model: [MovieModel] = MovieModel.allCases
    private var bag = Set<AnyCancellable>()
    
    @Published var movieSchedule: MovieSchedule? = nil
    @Published var filteredShowtimes: [ShowTime] = []
    
    @Published var allSchedules: [MovieSchedule] = []
    
    
    init(){
        setupBindings()
    }
    
    private func setupBindings() {
        $selectedMovieModel
            .map{$0 != nil}
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: &$isTheaterSelectable)
        
        Publishers.CombineLatest3($selectedMovieModel, $selectedTheaterName, $selectedDate)
                   .sink { [weak self] movie, theater, date in
                       self?.filterShowtimes(movie: movie, theater: theater, date: date)
                   }
                   .store(in: &bag)
        $query
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.errorMessage = nil
            })
            .flatMap { [weak self] query -> AnyPublisher<[MovieModel], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                return self.search(query: query)
                    .catch { [weak self] error -> Just<[MovieModel]> in
                        DispatchQueue.main.async {
                            self?.errorMessage = "검색 실패: \(error.localizedDescription)"
                        }
                        return Just([])
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.results = items
            }
            .store(in: &bag)
    }
    
    private func search(query: String) -> AnyPublisher<[MovieModel], Error> {
            Future<[MovieModel], Error> { [weak self] promise in
                guard let self else { return }
                let delay = Double(Int.random(in: 300...700)) / 1000.0
                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    let filtered = self.model.filter { $0.returnMovieName().lowercased().contains(query.lowercased()) }
                    promise(.success(filtered))
                }
            }
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    DispatchQueue.main.async { self?.isLoading = true }
                },
                receiveCompletion: { [weak self] _ in
                    DispatchQueue.main.async { self?.isLoading = false }
                }
            )
            .eraseToAnyPublisher()
        }
    
    func loadMovieSchedule() async {
        print("loadMovieSchedule() 호출됨")
            isLoading = true
            errorMessage = nil
            
            guard let dto = await MovieScheduleLoader.load(from: "MovieSchedule") else {
                DispatchQueue.main.async {
                    self.errorMessage = "MovieSchedule.json 파일을 불러올 수 없습니다."
                    self.isLoading = false
                }
                return
            }
            
            let domainData = dto.toDomain()
            
            DispatchQueue.main.async {
                self.movieSchedule = domainData
                self.isLoading = false
                print("ViewModel에 영화 데이터 저장 완료: \(domainData.movies.count)개 영화")
            }
        }
    
    private func filterShowtimes(movie: MovieModel?, theater: String, date: Date?) {
            guard let schedule = movieSchedule else {
                filteredShowtimes = []
                return
            }
            guard let movieName = movie?.returnMovieName() else {
                filteredShowtimes = []
                return
            }
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let selectedDateString = date.flatMap { dateFormatter.string(from: $0) }
            
            var showtimes: [ShowTime] = []
            
        
        for schedule in schedule.movies {
            if schedule.title != movieName{continue}
            for s in schedule.schedules {
                if let selectedDateString, let d = s.date,
                   dateFormatter.string(from: d) != selectedDateString {
                    continue
                }
                for area in s.areas {
                    if !theater.isEmpty && area.name != theater {
                        continue
                    }
                    for item in area.items {
                        showtimes.append(contentsOf: item.showtimes)
                    }
                }
            }
        }
            
        DispatchQueue.main.async {
            print("필터링 호출됨: 영화=\(movieName), 극장=\(theater), 날짜=\(date?.description ?? "없음")")
            self.filteredShowtimes = showtimes
            self.screeningMessage = showtimes.isEmpty
                            ? "선택한 극장에 상영시간표가 없습니다"
                            : ""
        }
    }
}
