//
//  megaBoxApp.swift
//  megaBox
//
//  Created by 은재 on 9/20/25.
//

import SwiftUI

@main
struct megaBoxApp: App {
    var body: some Scene {
        WindowGroup {
            RootRouterView()
        }
    }
}

private enum AppRoute {
    case splash
    case login
    case home
}

struct RootRouterView: View {
    @State private var route: AppRoute = .splash

    @AppStorage("is_logged_in") private var isLoggedIn: Bool = false
    @AppStorage("user_name")    private var userName: String = ""

    var body: some View {
        Group {
            switch route {
            case .splash:
                SplashView()
                    .task {
                        // (테스트용으로) 기존 로컬 로그인 키 삭제
                        KeychainService.delete(account: "login_id")
                        KeychainService.delete(account: "login_pwd")

                        try? await Task.sleep(nanoseconds: 800_000_000) // 0.8s

                        if let idData  = try? KeychainService.read(account: "login_id"),
                           let pwdData = try? KeychainService.read(account: "login_pwd"),
                           let id  = String(data: idData,  encoding: .utf8),
                           let _   = String(data: pwdData, encoding: .utf8) {
                            // 로컬 로그인 정보가 있으면 바로 홈
                            userName = id
                            isLoggedIn = true
                            route = .home
                        } else {
                            isLoggedIn = false
                            route = .login
                        }
                    }

            case .login:
                LoginView()
                    .onChange(of: isLoggedIn) { _, now in
                        if now { route = .home }
                    }

            case .home:
                TabView()
            }
        }
        // ⬇️ 카카오 REST 로그인 redirect 처리 (megabox://oauth?code=...)
        .onOpenURL { url in
            KakaoAuthManager.shared.handleRedirectURL(url) { result in
                switch result {
                case .success:
                    // 토큰은 KakaoAuthManager에서 Keychain에 저장됨
                    KakaoAuthManager.shared.fetchUserProfile { profileResult in
                        switch profileResult {
                        case .success(let profile):
                            let nickname = profile.kakao_account?.profile?.nickname ?? "사용자"
                            DispatchQueue.main.async {
                                // 마이페이지/헤더 등에서 쓰도록 저장
                                self.userName = nickname
                                // 자동 로그인 요구사항은 없지만, 현재 세션에서는 홈으로 보냄
                                self.isLoggedIn = true
                                self.route = .home
                            }
                        case .failure(let e):
                            print("fetchUserProfile error:", e)
                        }
                    }
                case .failure(let e):
                    print("Kakao login error:", e)
                }
            }
        }
        .animation(.default, value: route)
    }
}
