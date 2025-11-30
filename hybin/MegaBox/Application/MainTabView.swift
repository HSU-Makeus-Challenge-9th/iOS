//
//  MainTapView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/30/25.
//

import Foundation
import SwiftUI

struct MainTabView : View {
    
    @Environment(UserSessionManager.self) var userSessionManager
    
    var body : some View {
        TabView{
            Tab("Home", systemImage: "house.fill"){
                HomeView()
            }
            Tab("Lable", systemImage: "popcorn"){
                OrderItemView()
            }
            Tab("Profile", systemImage: "person.fill"){
                ProfileView()
            }
        }
        .fullScreenCover(isPresented: .constant(!userSessionManager.isLoggedIn)){
            LoginView()
                .environment(userSessionManager)
        }
    }
}


#Preview {
    MainTabView()
        .environment(UserSessionManager())
}

