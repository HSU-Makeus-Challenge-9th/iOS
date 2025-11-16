//
//  KakaoConfig.swift
//  MegaBox
//
//  Created by 전효빈 on 11/10/25.
//

import Foundation

enum KakaoConfig {
    static var restAPIKey = info("REST_APP_KEY")
    static let nativeAppKey = info("NATIVE_APP_KEY")
    static var redirectURI: String { "kakao\(nativeAppKey)://oauth" }
}

private extension KakaoConfig {
    static func info(_ key: String) -> String {
        Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
    }
}
