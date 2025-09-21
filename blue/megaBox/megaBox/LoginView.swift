//
//  LoginView.swift
//  megaBox
//
//  Created by 은재 on 9/21/25.
//

import SwiftUI

struct LoginView: View {
    // 입력 상태
    @State private var id: String = ""
    @State private var pw: String = ""

    // 피그마 메인 보라색(원하면 값 맞춰 수정해도 됨)
    private let primaryPurple = Color.purple

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            // 전체 하위뷰를 body에 VStack으로 배치
            VStack(spacing: 28) {
                topBar

                inputFields

                loginButton

                signUpText

                socialLoginRow

                umcPoster
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
    }

    //-------------------------------------------------//

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

    private var inputFields: some View {
        VStack(alignment: .leading, spacing: 22) {

            VStack(alignment: .leading, spacing: 8) {
                Text("아이디")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)

                TextField("", text: $id)
                    .textFieldStyle(.plain)
                Divider()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("비밀번호")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)

                SecureField("", text: $pw)
                    .textFieldStyle(.plain)
                Divider()
            }
        }
    }

    private var loginButton: some View {
        Button {
            // TODO: 로그인 액션
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

    // ▸ UMC 포스터(에셋) — 피그마 크기에 맞춰 조절
    private var umcPoster: some View {
        Image("umcLogo")
            .renderingMode(.original)
            .resizable()
            .scaledToFit()                               // 비율 유지
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 1, style: .continuous))
    }
}

#Preview {
    LoginView()
}
