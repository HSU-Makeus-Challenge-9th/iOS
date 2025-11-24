//
//  MovieAPIService.swift
//  MegaBox
//
//  Created by 전효빈 on 11/16/25.
//

import Foundation
import Moya
import Alamofire

enum TMBDConfig {
    static var apiAccessToken : String {
        guard let token = Bundle.main.infoDictionary?["TMDB_API_ACCESS_TOKEN"] as? String else {
            fatalError("Info.plist에 TMBD_API_ACCESS_TOKEN이 설정되지 않았습니다")
        }
        return token
    }
}

enum MovieAPI {
    case nowPlaying(language: String, page: Int, region: String)
    
}

final class MovieAPIService {
    static let shared = MovieAPIService()
    let provider : MoyaProvider<MovieAPI>
    
    private init() {
        self.provider = MoyaProvider<MovieAPI>()
    }
}

extension MovieAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }
    
    var path: String {
        switch self{
        case .nowPlaying:
            return "/3/movie/now_playing"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .nowPlaying:
            return .get
        }
    }
    
    var task: Task{
        switch self {
        case .nowPlaying(let language, let page, let region):
            let params: [String: Any] = [
                "language" : language,
                "page" : page,
                "region" : region
                ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": "Bearer \(TMBDConfig.apiAccessToken)",
            "accpet" : "apllication/json"
        ]
    }
}
