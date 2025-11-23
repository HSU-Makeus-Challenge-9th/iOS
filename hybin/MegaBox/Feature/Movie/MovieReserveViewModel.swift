import Foundation
import Combine
import SwiftUI


@Observable
class MovieReserveViewModel {
    
    @ObservationIgnored
    private let movieService = MovieAPIService.shared
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
    
    var movies: [MovieCardModel] = []
    let theaters: [String] = ["강남", "홍대", "신촌"]
    var selectedTheater: String? = nil
    var selectedMovie: MovieCardModel?
    var canReserve: Bool = false
    
    var schedules: [TheaterSchedule] = []
    var errorMessage: String? = nil
    
    init(selectedMovie: MovieCardModel) {
        self.selectedMovie = selectedMovie
        setupDebounce()
        loadSchedules()
    }
    
    //MARK: - 비동기 로드 함수
    
    @MainActor
    func loadAllMovies() async {
        do {
            let dto = try await movieService.provider.asyncRequest(
                .nowPlaying(language: "ko-KR", page: 1, region: "KR"),
                responseType: MovieResponseDTO.self
            )
            
            let imageBaseURL = "https://image.tmdb.org/t/p/w500"
            let backdropBaseURL = "https://image.tmdb.org/t/p/w780"
            
            // API 결과를 'movies' 변수에 매핑
            self.movies = dto.results.map { result in
                MovieCardModel(
                    id: result.id,
                    movieTitle : result.title,
                    moviePoster: "\(imageBaseURL)\(result.poster_path ?? "")",
                    releaseDate: result.release_date ?? "N/A",
                    ageLimit: "15", // (하드코딩)
                    bookRanking: 0.0, // (하드코딩)
                    totalAudience: "10만", // (하드코딩)
                    backdropPath: "\(backdropBaseURL)\(result.backdrop_path ?? "")",
                    originalTitle: result.original_title ?? "N/A",
                    overview: result.overview ?? "개요 정보가 없습니다."
                )
            }
            self.errorMessage = nil
        } catch {
            self.errorMessage = "전체 영화 목록 로드 실패: \(error.localizedDescription)"
            self.movies = []
        }
    }
    
    @MainActor
    func loadSchedules() {
        guard let movie = selectedMovie, let theaterName = selectedTheater else {
            self.schedules = []
            self.canReserve = false
            return
        }
        
        let selectedDate = calendarVM.selectedDate
        print("날짜: \(selectedDate), 영화: \(movie.movieTitle), 극장: \(theaterName) 시간표 로드 중...")
        
        // 1. JSON 파일 경로 찾기
        guard let url = Bundle.main.url(forResource: "MovieSchedule", withExtension: "json") else {
            self.errorMessage = "MovieSchedule.json 파일을 찾을 수 없습니다."
            return
        }
        
        // 2. JSON 데이터 읽기
        guard let data = try? Data(contentsOf: url) else {
            self.errorMessage = "MovieSchedule.json 파일을 읽을 수 없습니다."
            return
        }
        
        // 3. JSON 디코딩
        guard let responseDTO = try? JSONDecoder().decode(ScheduleResponseDTO.self, from: data) else {
            self.errorMessage = "MovieSchedule.json 디코딩 실패. DTO 구조 확인!"
            return
        }
        
        // 4. "새로운" DTO 구조에 맞춰 필터링
        
        // 4-1. 날짜 포맷 맞추기 (JSON의 "yyyy-MM-dd" 형식)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        
        // 4-2. "영화 ID"로 필터링
        // (주의! 님의 새 DTO는 영화 ID가 String, MovieCardModel은 Int입니다. 타입을 맞춰줍니다)
        guard let movieScheduleDTO = responseDTO.data.movies.first(where: {
            $0.id == String(movie.id)
        }) else {
            print("이 영화(\(movie.id))의 시간표가 DTO에 없습니다.")
            self.schedules = []
            self.canReserve = false
            return
        }
        
        // 4-3. "날짜"로 필터링
        guard let scheduleDTO = movieScheduleDTO.schedules.first(where: { $0.date == dateString }) else {
            print("이 날짜(\(dateString))의 시간표가 DTO에 없습니다.")
            self.schedules = []
            self.canReserve = false
            return
        }
        
        // 4-4. "극장(Area)"으로 필터링
        guard let areaDTO = scheduleDTO.areas.first(where: { $0.area == theaterName }) else {
            print("이 극장(\(theaterName))의 시간표가 DTO에 없습니다.")
            self.schedules = []
            self.canReserve = false
            return
        }
        
        // 5. 필터링된 "Area 1개"를 -> "TheaterSchedule 1개"로 매핑
        let finalSchedules = ScheduleMapper.mapToDomain(areas: [areaDTO])
        
        // 6. 최종 시간표를 View에 할당
        self.schedules = finalSchedules
        self.canReserve = !finalSchedules.isEmpty
        self.errorMessage = nil
        
        print("\(finalSchedules.first?.rooms.count ?? 0)개의 시간표 로드 성공!")
    }
    
    
    
    //    @MainActor
    //    func loadSchedules() async {
    //        guard let movie = selectedMovie, let _ = selectedTheater else {
    //            self.schedules = []
    //            self.canReserve = false
    //            return
    //        }
    //
    //        do {
    //            let fetchedSchedules = try await movieService.fetchSchedules(
    //                for: movie.id,
    //                on: calendarVM.selectedDate
    //            )
    //
    //            self.schedules = fetchedSchedules
    //            self.canReserve = !fetchedSchedules.isEmpty
    //            self.errorMessage = nil
    //
    //        } catch let error as ApiError {
    //            self.errorMessage = "시간표 로드 실패: \(error.localizedDescription)"
    //            self.schedules = []
    //            self.canReserve = false
    //        } catch {
    //            self.errorMessage = "알 수 없는 오류: \(error.localizedDescription)"
    //            self.schedules = []
    //            self.canReserve = false
    //        }
    //    }
}

