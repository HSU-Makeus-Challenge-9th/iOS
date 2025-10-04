import SwiftUI

@main
struct MegaBoxApp: App {
    
    @State var userSession = UserSessionManager()
    
    var body: some Scene {
        WindowGroup {
            Group
            {
                if userSession.isLoggedIn == false {
                    LoginView()

                } else {
                    MainTabView()

                }
            }
            .environment(userSession)
        }
    }
}
