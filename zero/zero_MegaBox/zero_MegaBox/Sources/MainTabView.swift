//
//  MainTabView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/2/25.
//

import SwiftUI

struct MainTabView: View {
    @Binding var path: NavigationPath
    var body: some View {
        TabView {
            Tab("홈", systemImage: "house.fill") {
//                HomeView(path: $path)
            }
            Tab("바로예매", systemImage: "play.laptopcomputer") {
                
            }
            Tab("모바일 오더", systemImage: "popcorn") {
                
            }
            Tab("마이페이지", systemImage: "person") {
                UserInfoView(path: $path)
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
