import SwiftUI

struct ContentView: View {
    @State private var showMainView: Bool = false

    // 로그인 여부 체크 (아이디 저장 여부)
    @AppStorage("login.id") private var storedId: String = ""

    var body: some View {
        ZStack {
            if showMainView {
                if storedId.isEmpty {
                    // 로그인 안 되어 있으면 로그인 화면
                    NavigationStack {
                        LoginView()
                    }
                } else {
                    // 로그인 되어 있으면 메인 탭뷰로
                    MainTabView()
                }
            } else {
                SplashView()
                    .onAppear {
                        // 스플래시 노출 후 1초 뒤 메인으로
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showMainView = true
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
