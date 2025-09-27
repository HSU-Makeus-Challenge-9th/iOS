import SwiftUI

struct MemberInfoManageView: View {
    @AppStorage("login.id") private var storedId: String = ""
    @AppStorage("profile.name") private var storedName: String = ""

    @State private var nameInput: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // 커스텀 네비게이션바
            MemberInfoNavBar(
                title: "회원정보 관리",
                backAction: { dismiss() }
            )

            MemberInfoBasicTitle()

            VStack(alignment: .leading, spacing: 0) {
                MemberInfoFixedRow(text: storedId)

                Divider()
                    .background(Color("grey02"))

                MemberInfoEditableRow(
                    placeholder: "이름을 입력하세요",
                    text: $nameInput,
                    onTapChange: {
                        storedName = nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                )

                Divider()
                    .background(Color("grey02"))
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            nameInput = storedName.isEmpty ? storedId : storedName
        }
    }
}

#Preview { NavigationStack { MemberInfoManageView() } }
