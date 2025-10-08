import SwiftUI

struct ContentView: View {
    @State private var showMainView: Bool = false

    // 아이디가 저장되어 있으면 회원 화면으로
    @AppStorage("login.id") private var storedId: String = ""

    var body: some View {
        ZStack {
            if showMainView {
                NavigationStack {
                    if storedId.isEmpty {
                        LoginView()
                    } else {
                        MemberView()
                    }
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
        .onAppear {
            // 폰트 체크 (디버그에서만)
            #if DEBUG
            UIFont.familyNames.sorted().forEach { familyName in
                print("*** \(familyName) ***")
                UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                    print(fontName)
                }
                print("---------------------")
            }
            #endif
        }
    }
}

#Preview {
    ContentView()
}
