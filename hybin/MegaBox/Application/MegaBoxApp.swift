import SwiftUI

@main
struct MegaBoxApp: App {
    
    @State var userSession = UserSessionManager()
    @State var kakaoAuthService = KakaoAuthService()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(userSession)
                .environment(kakaoAuthService)
                .onOpenURL { url in
                    Task {
                        let success = await kakaoAuthService.handleRedirect(url: url)
                        
                        if success {
                            await userSession.login(id: "kakaologin" , password: "kakaopassword")
                        }
                    }
                }
        }
    }
}
