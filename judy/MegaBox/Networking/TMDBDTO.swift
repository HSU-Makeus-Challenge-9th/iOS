import Foundation

struct TMDBNowPlayingResponse: Decodable {
    let page: Int
    let results: [TMDBMovieDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TMDBMovieDTO: Decodable {
    let id: Int
    let title: String             // localized title (ko-KR)
    let originalTitle: String     // original_title
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath   = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate  = "release_date"
        case originalTitle = "original_title"
        case voteAverage   = "vote_average"
    }
}
