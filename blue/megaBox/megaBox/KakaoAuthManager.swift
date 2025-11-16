import Foundation
import Alamofire
import UIKit

final class KakaoAuthManager: ObservableObject {
    static let shared = KakaoAuthManager()

    private let accessKey  = "kakao_access_token"
    private let refreshKey = "kakao_refresh_token"
    private let expiryKey  = "kakao_expires_at"

    // 1) 인가 페이지 열기
    func startLogin() {
        var comps = URLComponents(string: "https://kauth.kakao.com/oauth/authorize")!
        comps.queryItems = [
            .init(name: "client_id", value: KakaoConfig.restAPIKey),
            .init(name: "redirect_uri", value: KakaoConfig.redirectURI),
            .init(name: "response_type", value: "code")
            // 필요 시 스코프: .init(name: "scope", value: "profile_nickname,account_email")
        ]
        let url = comps.url!
        print("AUTH URL =>", url.absoluteString)

        if let scheme = URL(string: KakaoConfig.redirectURI)?.scheme,
           !UIApplication.shared.canOpenURL(URL(string: "\(scheme)://")!) {
            assertionFailure("URL Scheme \(scheme) 미등록. Info.plist > URL types 에 \(scheme) 추가 필요")
        }

        UIApplication.shared.open(url)
        print("AUTH URL =>", comps.url?.absoluteString ?? "nil")
    }


    // 2) redirect 처리 (megabox://oauth?code=...)
    func handleRedirectURL(_ url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        guard url.scheme == URL(string: KakaoConfig.redirectURI)?.scheme else { return }
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }

        if let e = comps.queryItems?.first(where: {$0.name == "error"})?.value {
            return completion(.failure(NSError(domain: "KakaoAuth", code: -1,
                                               userInfo: [NSLocalizedDescriptionKey: e])))
        }
        guard let code = comps.queryItems?.first(where: {$0.name == "code"})?.value else {
            return completion(.failure(NSError(domain: "KakaoAuth", code: -2,
                                               userInfo: [NSLocalizedDescriptionKey: "code not found"])))
        }
        exchangeCodeForToken(code: code, completion: completion)
    }

    // 3) 토큰 발급
    private func exchangeCodeForToken(code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let tokenURL = "https://kauth.kakao.com/oauth/token"
        var params: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": KakaoConfig.restAPIKey,
            "redirect_uri": KakaoConfig.redirectURI,
            "code": code
        ]
        if let s = KakaoConfig.clientSecret, !s.isEmpty {
            params["client_secret"] = s
        }

        print("TOKEN PARAMS =>", params)

        AF.request(tokenURL,
                   method: .post,
                   parameters: params,
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: ["Content-Type": "application/x-www-form-urlencoded;charset=utf-8"])
            .responseData { resp in
               
                if let data = resp.data, let body = String(data: data, encoding: .utf8) {
                    print("TOKEN RESP STATUS =>", resp.response?.statusCode ?? -1, "\nBODY =>", body)
                }

                switch resp.result {
                case .success(let data):
                    do {
                        let token = try JSONDecoder().decode(KakaoTokenResponse.self, from: data)
                        try self.saveTokens(token)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }


    // 4) 사용자 정보 (테스트/표시용)
    func fetchUserProfile(completion: @escaping (Result<KakaoProfile, Error>) -> Void) {
        guard let data = try? KeychainService.read(account: accessKey),
              let accessToken = String(data: data, encoding: .utf8) else {
            return completion(.failure(NSError(domain: "KakaoAuth", code: -3,
                                               userInfo: [NSLocalizedDescriptionKey: "No access token"])))
        }
        AF.request("https://kapi.kakao.com/v2/user/me",
                   method: .get,
                   headers: ["Authorization": "Bearer \(accessToken)"])
        .responseDecodable(of: KakaoProfile.self) { resp in
            switch resp.result {
            case .success(let profile): completion(.success(profile))
            case .failure(let error):   completion(.failure(error))
            }
        }
    }

    // 5) 만료 체크 후 리프레시
    func refreshTokenIfNeeded(completion: @escaping (Result<Void, Error>) -> Void) {
        if
               let expiryData = try? KeychainService.read(account: expiryKey),
               let expiryStr = String(data: expiryData, encoding: .utf8),
               let expiry = ISO8601DateFormatter().date(from: expiryStr),
               Date() < expiry {
                return completion(.success(())) // 아직 유효
            }

        guard let data = try? KeychainService.read(account: refreshKey),
              let refreshToken = String(data: data, encoding: .utf8) else {
            return completion(.failure(NSError(domain: "KakaoAuth", code: -4,
                                               userInfo: [NSLocalizedDescriptionKey: "No refresh token"])))
        }

        let url = "https://kauth.kakao.com/oauth/token"
        var params: [String: String] = [
            "grant_type": "refresh_token",
            "client_id": KakaoConfig.restAPIKey,
            "refresh_token": refreshToken
        ]
        if let secret = KakaoConfig.clientSecret { params["client_secret"] = secret }

        AF.request(url, method: .post, parameters: params,
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: ["Content-Type": "application/x-www-form-urlencoded;charset=utf-8"])
        .responseDecodable(of: KakaoTokenResponse.self) { [weak self] resp in
            switch resp.result {
            case .success(let token):
                do {
                    try self?.saveTokens(token, updating: true)
                    completion(.success(()))
                } catch { completion(.failure(error)) }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // 6) 키체인 저장
    private func saveTokens(_ token: KakaoTokenResponse, updating: Bool = false) throws {
        if let access = token.access_token {
            try KeychainService.save(Data(access.utf8), account: accessKey)
        }
        if let refresh = token.refresh_token {
            try KeychainService.save(Data(refresh.utf8), account: refreshKey)
        } else if !updating {
            // 최초 발급인데 refresh_token이 없을 수 있음(카카오 정책). 무시 가능.
        }
        if let sec = token.access_token_expires_in ?? token.expires_in {
            let expiry = Date().addingTimeInterval(TimeInterval(sec))
            let iso = ISO8601DateFormatter().string(from: expiry)
            try KeychainService.save(Data(iso.utf8), account: expiryKey)
        }
    }

    // 7) 로그아웃/삭제
    func clearTokens() {
        KeychainService.delete(account: accessKey)
        KeychainService.delete(account: refreshKey)
        KeychainService.delete(account: expiryKey)
    }
}

struct KakaoTokenResponse: Decodable {
    let token_type: String?
    let access_token: String?
    let expires_in: Int?
    let refresh_token: String?
    let refresh_token_expires_in: Int?
    let scope: String?
    // 문서 변형 대비
    let access_token_expires_in: Int?
}

struct KakaoProfile: Decodable {
    let id: Int64
    let kakao_account: KakaoAccount?
    struct KakaoAccount: Decodable {
        let profile: Profile?
        let email: String?
        struct Profile: Decodable {
            let nickname: String?
            let thumbnail_image_url: String?
            let profile_image_url: String?
        }
    }
}
