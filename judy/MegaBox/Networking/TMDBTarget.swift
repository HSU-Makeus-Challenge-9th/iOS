import Foundation
import Moya
import Alamofire

enum TMDBTarget {
    case nowPlaying(page: Int)
}

extension TMDBTarget: TargetType {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }

    var path: String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        switch self {
        case let .nowPlaying(page):
            let params: [String: Any] = [
                "api_key": Secrets.tmdbAPIKey,
                "language": "ko-KR",
                "page": page,
                "region": "KR"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        ["Accept": "application/json"]
    }

    var sampleData: Data {
        Data()
    }
}
