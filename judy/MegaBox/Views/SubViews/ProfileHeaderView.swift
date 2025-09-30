import SwiftUI

struct ProfileHeaderView: View {
    let displayName: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("\(displayName)님")
                        .font(.pretend(type: .bold, size: 20))
                        .foregroundStyle(.black)

                    // WELCOME 뱃지
                    Text("WELCOME")
                        .font(.pretend(type: .semibold, size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("green01"))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                Text("멤버십 포인트 500P")
                    .font(.pretend(type: .regular, size: 14))
                    .foregroundStyle(.gray)
            }

            Spacer()

            // 회원정보 버튼
            NavigationLink {
                MemberInfoManageView()
            } label: {
                Text("회원정보")
                    .font(.pretend(type: .regular, size: 14))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color("grey07"))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }
}
