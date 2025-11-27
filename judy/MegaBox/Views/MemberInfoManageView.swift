import SwiftUI

struct MemberInfoManageView: View {
    @State private var nameInput: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: LoginViewModel

    // Keychain에서 읽기
    private var storedId: String {
        KeyChainService.read(KCKey.username)
            .flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }
    private var storedName: String {
        KeyChainService.read(KCKey.displayName)
            .flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // 커스텀 네비게이션 바
            MemberInfoNavBar(
                title: "회원정보 관리",
                backAction: { dismiss() }
            )

            MemberInfoBasicTitle()

            VStack(alignment: .leading, spacing: 0) {
                // 아이디 고정 노출
                MemberInfoFixedRow(text: storedId)

                // 이름 수정 → Keychain 저장 + ViewModel 반영
                MemberInfoEditableRow(
                    placeholder: "이름을 입력하세요",
                    text: $nameInput,
                    onTapChange: {
                        let newName = nameInput
                            .trimmingCharacters(in: .whitespacesAndNewlines)

                        KeyChainService.save(
                            Data(newName.utf8),
                            for: KCKey.displayName
                        )
                        vm.displayName = newName
                    }
                )

                Divider().background(Color("grey02"))
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
