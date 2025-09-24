//
//  RootView.swift
//  megaBox
//
//  Created by 은재 on 9/21/25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            SplashView()
                .tabItem { Label("Splash", systemImage: "sparkles") }

            LoginView()
                .tabItem { Label("Login", systemImage: "person") }

            TicketView()
                .tabItem { Label("Ticket", systemImage: "ticket") }
        }
    }
}

#Preview {
    RootView()
}
