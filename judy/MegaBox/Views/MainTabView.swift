import SwiftUI

struct MainTabView: View {
    @State private var selected: Int = 0
    @EnvironmentObject var vm: LoginViewModel

    var body: some View {
        TabView(selection: $selected) {

            // 홈
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: selected == 0 ? "house.fill" : "house")
                Text("홈")
            }
            .tag(0)

            // 바로 예매
            NavigationStack {
                MovieBookingView()
            }
            .tabItem {
                Image(systemName: selected == 1 ? "play.rectangle.fill" : "play.rectangle")
                Text("바로 예매")
            }
            .tag(1)

            // 모바일 오더
            NavigationStack {
                MobileOrderView()
            }
            .tabItem {
                Image(systemName: selected == 2 ? "popcorn.fill" : "popcorn")
                Text("모바일 오더")
            }
            .tag(2)

            // 마이 페이지
            NavigationStack {
                MemberView()
            }
            .tabItem {
                Image(systemName: selected == 3 ? "person.crop.circle.fill" : "person.crop.circle")
                Text("마이 페이지")
            }
            .tag(3)
        }
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(LoginViewModel()) // 미리보기용 주입
    }
}
#endif
