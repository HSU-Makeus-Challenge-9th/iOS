import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct MegaBoxApp: App {
    @StateObject private var auth = LoginViewModel()

    init() {
        let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String ?? ""
        KakaoSDK.initSDK(appKey: key)
        
        // 진단 로그
        print("BundleID:", Bundle.main.bundleIdentifier ?? "nil")
        print("REST:", KakaoConfig.restApiKey.prefix(6), "…")
        print("NATIVE:", KakaoConfig.nativeAppKey.prefix(6), "…")
        print("REDIRECT:", KakaoConfig.redirectURI)
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if auth.isLoggedIn {
                    MainTabView().environmentObject(auth)
                } else {
                    LoginView().environmentObject(auth)
                }
            }
            .onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
    }
}
