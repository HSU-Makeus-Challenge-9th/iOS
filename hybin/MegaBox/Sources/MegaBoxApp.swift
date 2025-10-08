import SwiftUI

@main
struct MegaBoxApp: App {
    
    @State var userSession = UserSessionManager()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(userSession)
        }
    }
}
