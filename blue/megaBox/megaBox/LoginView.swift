//
//  LoginView.swift
//  megaBox
//
//  Created by 은재 on 9/21/25.
//

import SwiftUI
import Observation

@Observable
final class LoginModel {
    var id: String = ""
    var pwd: String = ""
}

@Observable
final class LoginViewModel {
    var model: LoginModel = LoginModel()
}

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    
    @AppStorage("login_id")  private var storedId: String = ""
    @AppStorage("login_pwd") private var storedPwd: String = ""
    @AppStorage("is_logged_in") private var isLoggedIn: Bool = false

    @State private var showLoginError = false
    private let primaryPurple = Color.purple

    var body: some View {
        @Bindable var vm = viewModel

        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 28) {
                topBar

                // 입력 영역
                VStack(alignment: .leading, spacing: 22) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text("아이디")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)

                        TextField("megabox123", text: $vm.model.id)
                            .textFieldStyle(.plain)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        Divider()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("비밀번호")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)

                        SecureField("********", text: $vm.model.pwd)
                            .textFieldStyle(.plain)
                        Divider()
                    }
                }

                // 로그인 버튼
                Button {
                                    let id = vm.model.id.trimmingCharacters(in: .whitespacesAndNewlines)
                                    let pw = vm.model.pwd

                                    if storedId.isEmpty || storedPwd.isEmpty {
                                     
                                        storedId = id
                                        storedPwd = pw
                                        isLoggedIn = true
                                    } else if id == storedId && pw == storedPwd {
                                    
                                        isLoggedIn = true
                                    } else {
                                        showLoginError = true
                                    }
                                } label: {
                                    Text("로그인")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                }
                .background(primaryPurple)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.top, 4)
                .alert("아이디 또는 비밀번호가 올바르지 않습니다.", isPresented: $showLoginError) {
                                    Button("확인", role: .cancel) { }
                                }

                signUpText
                socialLoginRow
                umcPoster
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
    }

    private var topBar: some View {
        HStack {
            Spacer()
            Text("로그인")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.black)
            Spacer()
        }
        .padding(.top, 8)
    }

    private var signUpText: some View {
        Text("회원가입")
            .font(.system(size: 14))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var socialLoginRow: some View {
        HStack(spacing: 48) {
            Image("naverLogo")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)

            Image("kakaoLogo")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)

            Image("appleLogo")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 6)
    }

    private var umcPoster: some View {
        Image("umcLogo")
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 1, style: .continuous))
    }
}

#Preview {
    LoginView()
}
