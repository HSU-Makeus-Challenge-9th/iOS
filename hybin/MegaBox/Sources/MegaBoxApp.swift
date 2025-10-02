import SwiftUI

@main
struct MegaBoxApp: App {
    var body: some Scene {
        WindowGroup {
            
                        ProfileView(viewModel: LoginViewModel())
//                                    ProfileDetailView(viewModel:LoginViewModel())
//                        LoginView()
        }
    }
}
