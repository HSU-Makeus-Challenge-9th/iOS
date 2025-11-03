//
//  TabView.swift
//  megaBox
//
//  Created by 은재 on 10/1/25.
//

import SwiftUI

enum Tab: Hashable {
    case home
    case search
    case ticket
    case profile
}

struct TabView: View {
    @State private var selection: Tab = .home

    var body: some View {
        SwiftUI.TabView(selection: $selection) {

            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            SearchView()
                .tabItem {
                    Label("검색", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)

            BookingView()
                .tabItem {
                    Label("예매", systemImage: "ticket")
                }
                .tag(Tab.ticket)

            UserInfo()
                .tabItem {
                    Label("프로필", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(.blue) 
    }
}

#Preview {
    TabView()
}
