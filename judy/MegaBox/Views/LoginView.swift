import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @State private var isKakaoLoading = false

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Text("로그인")
                    .font(.pretend(type: .semibold, size: 24))
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.top)

            // 아이디 / 비밀번호
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    TextField("아이디", text: $viewModel.id)
                        .textFieldStyle(.plain)
                        .font(.pretend(type: .regular, size: 16))
                        .foregroundStyle(Color("grey03"))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    Divider().background(Color("grey02"))
                }

                VStack(alignment: .leading, spacing: 8) {
                    SecureField("비밀번호", text: $viewModel.pwd)
                        .textFieldStyle(.plain)
                        .font(.pretend(type: .regular, size: 16))
                        .foregroundStyle(Color("grey03"))
                    Divider().background(Color("grey02"))
                }
            }

            // 일반 로그인
            Button {
                viewModel.login()
            } label: {
                Text("로그인")
                    .font(.pretend(type: .bold, size: 17))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .buttonStyle(.plain)
            .background(viewModel.isLoginEnabled ? Color("purple03") : Color.gray.opacity(0.4))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(.black.opacity(0.35), lineWidth: 1))
            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 3)
            .disabled(!viewModel.isLoginEnabled)

            Text("회원가입")
                .font(.pretend(type: .regular, size: 12))
                .foregroundStyle(Color("grey04"))
                .padding(.top, 4)

            // 소셜 버튼
            HStack {
                Button {} label: {
                    Image("naverBtn").resizable().scaledToFit()
                }

                Spacer(minLength: 0)

                // 카카오 로그인
                Button {
                    isKakaoLoading = true
                    KakaoAuthManager.shared.login { result in
                        DispatchQueue.main.async {
                            isKakaoLoading = false
                            switch result {
                            case .success:
                                // Keychain에서 표시명 복원 (자동 로그인/마이페이지 노출용)
                                if let nameData = KeyChainService.read(KCKey.displayName),
                                   let name = String(data: nameData, encoding: .utf8),
                                   !name.isEmpty {
                                    viewModel.displayName = name
                                }
                                viewModel.isLoggedIn = true   // 메인 탭으로 전환
                            case .failure(let e):
                                print("Kakao login failed:", e.localizedDescription)
                            }
                        }
                    }
                } label: {
                    (isKakaoLoading ? Image(systemName: "hourglass") : Image("kakaoBtn"))
                        .resizable().scaledToFit()
                }

                Spacer(minLength: 0)

                Button {} label: {
                    Image("appleBtn").resizable().scaledToFit()
                }
            }
            .frame(height: 40)
            .frame(maxWidth: 266)
            .padding(.top, 4)

            Image("umcPoster")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.vertical, 12)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 91)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white.ignoresSafeArea())
    }
}
