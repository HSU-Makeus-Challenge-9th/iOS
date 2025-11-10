import Foundation
import Combine
import SwiftUI


@Observable
class MovieReserveViewModel {
    
    @ObservationIgnored
    private let movieService = MovieService()
    
    var calendarVM: CalendarViewModel = .init()
    
    //MARK: - 시트뷰
    
    @ObservationIgnored
    private let searchTextSubject = PassthroughSubject<String, Never>()

    var searchText: String = "" {
        didSet {
            searchTextSubject.send(searchText)
        }
    }
    
    var debouncedText: String = ""
    
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    
    private func setupDebounce() {
        searchTextSubject
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] newText in
                self?.debouncedText = newText
            }
            .store(in: &cancellables)
    }
    
    //MARK: - 리저브 뷰
    
    var movies: [MovieModel] = []
    let theaters: [String] = ["강남", "홍대", "신촌"]
    var selectedTheater: String? = nil
    var selectedMovie: MovieModel?
    var canReserve: Bool = false
    
    var schedules: [TheaterSchedule] = []
    var errorMessage: String? = nil
    
    init(selectedMovie: MovieModel) {
        self.selectedMovie = selectedMovie
        setupDebounce()
    }
    
    //MARK: - 비동기 로드 함수
    
    @MainActor
    func loadAllMovies() async {
        do {
            self.movies = try await movieService.fetchMovies()
            self.errorMessage = nil
        } catch {
            self.errorMessage = "전체 영화 목록 로드 실패: \(error.localizedDescription)"
            self.movies = []
        }
    }
    
    @MainActor
    func loadSchedules() async {
        guard let movie = selectedMovie, let _ = selectedTheater else {
            self.schedules = []
            self.canReserve = false
            return
        }
        
        do {
            let fetchedSchedules = try await movieService.fetchSchedules(
                for: movie.id,
                on: calendarVM.selectedDate
            )
            
            self.schedules = fetchedSchedules
            self.canReserve = !fetchedSchedules.isEmpty
            self.errorMessage = nil
            
        } catch let error as ApiError {
            self.errorMessage = "시간표 로드 실패: \(error.localizedDescription)"
            self.schedules = []
            self.canReserve = false
        } catch {
            self.errorMessage = "알 수 없는 오류: \(error.localizedDescription)"
            self.schedules = []
            self.canReserve = false
        }
    }
}

