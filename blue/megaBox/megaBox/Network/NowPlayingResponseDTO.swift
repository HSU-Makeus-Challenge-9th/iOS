import Foundation

struct NowPlayingResponseDTO: Codable {
    let dates: DatesDTO
    let page: Int
    let results: [MovieItemDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct DatesDTO: Codable {
    let maximum: String
    let minimum: String
}

struct MovieItemDTO: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let originalLanguage: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let adult: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, adult
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
