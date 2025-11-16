import SwiftUI

struct MemberView: View {
    @EnvironmentObject var vm: LoginViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // 프로필 영역
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .foregroundStyle(.gray.opacity(0.6))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(vm.displayName.isEmpty ? "회원님" : vm.displayName)
                                .font(.pretend(type: .semibold, size: 18))
                            Text("환영합니다 👋")
                                .font(.pretend(type: .regular, size: 14))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    ClubMembershipButton()
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("로그아웃") {
                        vm.logout()
                    }
                }
            }
        }
    }
}

#Preview {
    MemberView()
        .environmentObject(LoginViewModel())
}
