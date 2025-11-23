import Foundation
import Moya

enum TMDBAPI {
    case nowPlaying(page: Int)
}

extension TMDBAPI: TargetType {
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
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    // 🔑 Info.plist -> TMDB_API_KEY 읽어오는 부분
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String,
              key.isEmpty == false else {
            assertionFailure("⚠️ TMDB_API_KEY가 Info.plist에 제대로 설정되지 않았습니다.")
            return ""
        }
        return key
    }

    var task: Task {
        switch self {
        case .nowPlaying(let page):
            // 이미 만들어둔 NowPlayingRequestDTO 재사용
            let requestDTO = NowPlayingRequestDTO(
                apiKey: apiKey,
                language: "ko-KR",
                page: page,
                region: "KR"
            )

            return .requestParameters(
                parameters: requestDTO.parameters,
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String : String]? {
        [
            "accept": "application/json"
        ]
    }
}

