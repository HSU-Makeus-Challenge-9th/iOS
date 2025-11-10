//
//  KakaoAuthService.swift
//  MegaBox
//
//  Created by 전효빈 on 11/10/25.
//

import Foundation
import Alamofire
import SwiftUI

@Observable
final class KakaoAuthService  {
    
    func startKakaoLogin() {
        let authURLString = "https://kauth.kakao.com/oauth/authorize?client_id=\(KakaoConfig.restAPIKey)&redirect_uri=\(KakaoConfig.redirectURI)&response_type=code"
        
        guard let authURL = URL(string: authURLString) else{
            print("카카오 인증 URL 생성 실패")
            return
        }
        
        if UIApplication.shared.canOpenURL(authURL) {
            UIApplication.shared.open(authURL)
        }
    }
    
    func handleRedirect(url: URL) async -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems,
              let code = queryItems.first(where: { $0.name == "code" })?.value else {
            print("리다이렉트 URL에서 인증코드를 찾을 수 없습니다")
            return false
        }
        print("인증 코드 획득: \(code)")
        return await fetchToken(code: code)
    }
    
    private func fetchToken(code: String) async -> Bool {
        let url = "https://kauth.kakao.com/oauth/token"
        let parameters: [String: String] = [
            "grant_type":"authorization_code",
            "client_id":KakaoConfig.restAPIKey,
            "redirect_uri":KakaoConfig.redirectURI,
            "code":code
        ]
        
        do {
            let response = try await AF.request(url,method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
                .validate()
                .serializingDecodable(KakaoTokenResponse.self)
                .value
            
            print("토큰 획득 성공 : \(response.accessToken)")
            
            try? KeychainService.save(Data(response.accessToken.utf8),account: "kakaoAccessToken")
            try? KeychainService.save(Data(response.refreshToken.utf8),account: "kakaoRefreshToken")
            
            return true
        } catch {
            print("토큰 요청 실패(Alamofire): \(error)")
            return false
        }
    }
}
    nonisolated struct KakaoTokenResponse: Decodable,Sendable {
        let accessToken: String
        let tokenType: String
        let refreshToken: String
        let expiresIn: Int
        let refreshTokenExpiresIn: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case refreshToken = "refresh_token"
            case expiresIn = "expires_in"
            case refreshTokenExpiresIn = "refresh_token_expires_in"
        }
    }
