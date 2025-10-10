import SwiftUI

struct MainTabView: View {
    @State private var selected = 0

    var body: some View {
        TabView(selection: $selected) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: selected == 0 ? "house.fill" : "house")
                Text("홈")
            }
            .tag(0)

            NavigationStack {
                MemberView()  // 기존 회원 화면
            }
            .tabItem {
                Image(systemName: selected == 1 ? "person.text.rectangle.fill" : "person.text.rectangle")
                Text("마이")
            }
            .tag(1)
        }
    }
}
