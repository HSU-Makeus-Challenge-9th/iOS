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

    @Published var showScreeningInfo: Bool = false
    @Published var screeningMessage: String = "선택한 극장에 상영시간표가 없습니다"
    @Published var selectedCinemaType: String = ""
        
    
    @Published var query: String = ""
    @Published var results: [MovieModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var model: [MovieModel] = MovieModel.allCases
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        $selectedMovieModel
            .map{$0 != nil}
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: &$isTheaterSelectable)
        
        Publishers.CombineLatest3($selectedMovieModel, $selectedTheaterName, $selectedDate)
                    .map { movie, theater, date in
                        if let movie, !theater.isEmpty, let date {
                            let calendar = Calendar.current
                            let today = Date()
                            if !calendar.isDate(date, inSameDayAs: today) { return false }
                            return theater != "신촌"
                        }
                        return false
                    }
                    .sink { [weak self] show in
                        self?.showScreeningInfo = show
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
    
}
