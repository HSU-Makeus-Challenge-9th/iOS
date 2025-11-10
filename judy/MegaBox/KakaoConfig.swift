import Foundation

/// Kakao 관련 설정값을 Info.plist에서 꺼내 쓰는 헬퍼
enum KakaoConfig {

    /// kakao 네이티브 앱 키
    static var nativeAppKey: String {
        info("KAKAO_NATIVE_APP_KEY")
    }

    /// REST API Key (서버/웹 인증용)
    static var restApiKey: String {
        info("KAKAO_REST_API_KEY")
    }

    /// 커스텀 URL 스킴 (URL Types에 등록한 값)
    static var callbackScheme: String {
        let v: String = infoOptional("KAKAO_CALLBACK_SCHEME") ?? "kakao\(nativeAppKey)"
        return v
    }

    /// 리다이렉트 URI
    static var redirectURI: String {
        let v: String = infoOptional("KAKAO_REDIRECT_URI") ?? "\(callbackScheme)://oauth"
        return v
    }
}

// MARK: - plist helper
private extension KakaoConfig {
    static func info(_ key: String) -> String {
        Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
    }
    static func infoOptional(_ key: String) -> String? {
        Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
}
