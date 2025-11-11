import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

// MARK: - DTO

struct KakaoToken: Codable, Sendable {
    let access_token: String
    let token_type: String
    let refresh_token: String?
    let expires_in: Int
}

struct KakaoMe: Codable, Sendable {
    struct Account: Codable, Sendable {
        struct Profile: Codable, Sendable {
            let nickname: String?
        }
        let profile: Profile?
    }
    let kakao_account: Account?
}

// MARK: - KakaoAuthManager

final class KakaoAuthManager {

    // 싱글턴
    static let shared = KakaoAuthManager()
    private init() {}

    // MARK: Public APIs

    /// 카카오 로그인 진입점
    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk(completion: completion)
        } else {
            loginWithKakaoAccount(completion: completion)
        }
    }

    /// 로그인 후 사용자 정보 간단 조회 (닉네임 등)
    func fetchProfile(completion: @escaping (Result<String?, Error>) -> Void) {
        UserApi.shared.me { me, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            let nickname = me?.kakaoAccount?.profile?.nickname
            DispatchQueue.main.async { completion(.success(nickname)) }
        }
    }

    /// 로그아웃
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        UserApi.shared.logout { error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            DispatchQueue.main.async { completion(.success(())) }
        }
    }

    /// 앱으로 돌아오는 URL 처리 (Scene/WindowGroup onOpenURL 에서 호출 가능)
    @discardableResult
    func handleOpenURL(_ url: URL) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }

    // MARK: Private

    private func loginWithKakaoTalk(completion: @escaping (Result<Void, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { _, error in
            if let error = error {
                // 사용자가 카톡 로그인 취소/실패하면 계정 로그인으로 폴백
                self.loginWithKakaoAccount(completion: completion)
                return
            }
            DispatchQueue.main.async { completion(.success(())) }
        }
    }

    private func loginWithKakaoAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount { _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            DispatchQueue.main.async { completion(.success(())) }
        }
    }
}
