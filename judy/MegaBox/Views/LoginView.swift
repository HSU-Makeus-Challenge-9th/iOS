import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @AppStorage("login.id") private var storedId: String = ""
    @AppStorage("login.pwd") private var storedPwd: String = ""
    @State private var goToMember: Bool = false

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

            // 아이디/비밀번호
            VStack(alignment: .leading, spacing: 16) {
                // 아이디
                VStack(alignment: .leading, spacing: 8) {
                    TextField("아이디", text: $viewModel.id)
                        .textFieldStyle(.plain)
                        .font(.pretend(type: .regular, size: 16))
                        .foregroundStyle(Color("grey03"))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)

                    Divider()
                        .background(Color("grey02"))
                }

                // 비밀번호 (보안 입력)
                VStack(alignment: .leading, spacing: 8) {
                    SecureField("비밀번호", text: $viewModel.pwd)
                        .textFieldStyle(.plain)
                        .font(.pretend(type: .regular, size: 16))
                        .foregroundStyle(Color("grey03"))

                    Divider()
                        .background(Color("grey02"))
                }
            }

            // 로그인 버튼
            Button {
                if viewModel.isLoginEnabled {
                    storedId = viewModel.id
                    storedPwd = viewModel.pwd
                    goToMember = true
                }
            } label: {
                Text("로그인")
                    .font(.pretend(type: .bold, size: 17))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .buttonStyle(.plain)
            .background(Color("purple03"))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black.opacity(0.35), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 3)

            // 회원가입
            Text("회원가입")
                .font(.pretend(type: .regular, size: 12))
                .foregroundStyle(Color("grey04"))
                .padding(.top, 4)

            // 소셜 버튼
            HStack {
                Button {
                } label: {
                    Image("naverBtn")
                        .resizable()
                        .scaledToFit()
                }

                Spacer(minLength: 0)

                Button {
                } label: {
                    Image("kakaoBtn")
                        .resizable()
                        .scaledToFit()
                }

                Spacer(minLength: 0)

                Button {
                } label: {
                    Image("appleBtn")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(height: 40)
            .frame(maxWidth: 266)
            .padding(.top, 4)

            // 배너
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
        .navigationDestination(isPresented: $goToMember) {
            MemberView()
        }
    }
}
