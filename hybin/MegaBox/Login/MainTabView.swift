//
//  MainTapView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/30/25.
//

import Foundation
import SwiftUI

struct MainTabView : View {
    var body : some View {
        TabView{
            Tab("Home", systemImage: "house.fill"){
                HomeView()
            }
            Tab("Profile", systemImage: "person.fill"){
                ProfileView()
            }
            
        }

    }
}


#Preview {
    MainTabView()
        .environment(UserSessionManager())
}

