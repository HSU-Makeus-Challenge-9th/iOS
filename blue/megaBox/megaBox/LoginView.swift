import SwiftUI
import Observation

struct LoginView: View {
    @State private var viewModel = LoginViewModel()

    @AppStorage("is_logged_in") private var isLoggedIn: Bool = false
    @AppStorage("user_name")    private var userName: String = ""

    @State private var showLoginError = false
    private let primaryPurple = Color.purple

    var body: some View {
        @Bindable var vm = viewModel

        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 28) {
                HStack { Spacer(); Text("로그인").font(.system(size: 28, weight: .bold)); Spacer() }

                VStack(alignment: .leading, spacing: 22) {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("아이디").font(.system(size: 16)).foregroundStyle(.secondary)
                        TextField("megabox123", text: $vm.model.id)
                            .textFieldStyle(.plain)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        Divider()
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("비밀번호").font(.system(size: 16)).foregroundStyle(.secondary)
                        SecureField("********", text: $vm.model.pwd)
                            .textFieldStyle(.plain)
                        Divider()
                    }
                }

                Button {
                    let id = vm.model.id.trimmingCharacters(in: .whitespacesAndNewlines)
                    let pw = vm.model.pwd

                    if !viewModel.credentialsExist() {
                        do {
                            try viewModel.saveCredentials(id: id, pwd: pw)   // Keychain 저장
                            userName = id                                      // 마이페이지 표시용
                            isLoggedIn = true                                  // 홈으로 진입
                        } catch {
                            showLoginError = true
                        }
                    } else if viewModel.validate(id: id, pwd: pw) {
                        userName = id
                        isLoggedIn = true
                    } else {
                        showLoginError = true
                    }
                } label: {
                    Text("로그인")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 16)
                }
                .background(primaryPurple)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.top, 4)
                .alert("아이디 또는 비밀번호가 올바르지 않습니다.", isPresented: $showLoginError) {
                    Button("확인", role: .cancel) { }
                }

                Text("회원가입").font(.system(size: 14)).foregroundStyle(.secondary)
                HStack(spacing: 48) {
                    Button(action: {
                        print("네이버 로그인 버튼 클릭")
                    }) {
                        Image("naverLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                    }
                    .buttonStyle(.plain) 
                    .contentShape(Rectangle()) // 터치 영역 이미지 크기로만 제한

                    Button(action: {
                        print("카카오 로그인 버튼 클릭")
                        KakaoAuthManager.shared.startLogin()
                    }) {
                        Image("kakaoLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())

                    Button(action: {
                        print("애플 로그인 버튼 클릭")
                    }) {
                        Image("appleLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 6)

                Image("umcLogo").resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 1))
            }
            .padding(.horizontal, 24).padding(.vertical, 16)
        }
    }
}

#Preview {
    LoginView()
}

