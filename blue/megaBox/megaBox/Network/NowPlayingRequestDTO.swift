//
//  NowPlayingRequestDTO.swift
//  megaBox
//
//  Created by 은재 on 11/17/25.
//

import Foundation

struct NowPlayingRequestDTO {
    let apiKey: String
    let language: String
    let page: Int
    let region: String

    var parameters: [String: Any] {
        [
            "api_key": apiKey,
            "language": language,
            "page": page,
            "region": region
        ]
    }
}
