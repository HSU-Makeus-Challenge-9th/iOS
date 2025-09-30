import SwiftUI

struct MemberView: View {
    @AppStorage("login.id") private var userId: String = ""
    @AppStorage("profile.name") private var storedName: String = ""

    // 저장된 이름이 있으면 그걸, 없으면 아이디를 헤더에 표기
    private var displayName: String {
        storedName.isEmpty ? userId : storedName
    }

    var body: some View {
        VStack(spacing: 16) {
            ProfileHeaderView(displayName: displayName)
            ClubMembershipButton()
            StatusInfoView()
            ReservationMenuView()
            Spacer()
        }
        .padding()
        .background(Color.white)
        .navigationTitle("회원 화면")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview { NavigationStack { MemberView() } }
