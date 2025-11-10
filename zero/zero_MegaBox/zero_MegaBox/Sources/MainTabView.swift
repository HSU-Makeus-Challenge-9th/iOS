//
//  MainTabView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/2/25.
//

import SwiftUI

struct MainTabView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var loginModel: LoginViewModel
    
    var body: some View {
        TabView {
            HomeView(path: $path)
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }

            Text("바로예매")
                .tabItem {
                    Label("바로예매", systemImage: "play.laptopcomputer")
                }

            Text("모바일 오더")
                .tabItem {
                    Label("모바일 오더", systemImage: "popcorn")
                }

            UserInfoView(path: $path)
                .environmentObject(loginModel)
                .tabItem {
                    Label("마이페이지", systemImage: "person")
                }
        }
        .tint(Color("black"))
        .navigationBarBackButtonHidden(true)
    }
}
//
//#Preview {
//    MainTabView(path: $path)
//}
