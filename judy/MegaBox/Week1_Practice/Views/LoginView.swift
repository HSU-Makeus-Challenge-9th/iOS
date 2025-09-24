import SwiftUI

struct LoginView: View {
    @State private var userId: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 24) {
            // 상단 타이틀
            HStack {
                Spacer()
                Text("로그인")
                    .font(.pretend(type: .semibold, size: 24))
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.top, 16)

            // 아이디/비밀번호
            VStack(alignment: .leading, spacing: 16) {

                // 아이디
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .leading) {
                        if userId.isEmpty {
                            Text("아이디")
                                .font(.pretend(type: .regular, size: 16))
                                .foregroundStyle(Color("grey03"))   // placeholder 색
                        }
                        TextField("", text: $userId)
                            .textFieldStyle(.plain)
                            .font(.pretend(type: .regular, size: 16))
                            .foregroundStyle(Color("grey03"))       // 텍스트 색
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color("grey02"))
                }

                // 비밀번호
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .leading) {
                        if password.isEmpty {
                            Text("비밀번호")
                                .font(.pretend(type: .regular, size: 16))
                                .foregroundStyle(Color("grey03"))
                        }
                        SecureField("", text: $password)
                            .textFieldStyle(.plain)
                            .font(.pretend(type: .regular, size: 16))
                            .foregroundStyle(Color("grey03"))
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color("grey02"))
                }
            }

            // 로그인 버튼
            Button(action: {
                // TODO: 로그인 액션
            }) {
                Text("로그인")
                    .font(.pretend(type: .bold, size: 17))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .buttonStyle(.plain)
            .background(Color("purple03"))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.black.opacity(0.35), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 3)

            // 회원가입
            Text("회원가입")
                .font(.pretend(type: .regular, size: 12))
                .foregroundStyle(Color("grey04"))
                .padding(.top, 4)

            // 소셜 버튼 (기존 간격 유지)
            HStack(alignment: .top, spacing: 0) {
                Button(action: {}) {
                    Image("naverBtn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)

                Spacer(minLength: 0)

                Button(action: {}) {
                    Image("kakaoBtn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)

                Spacer(minLength: 0)

                Button(action: {}) {
                    Image("appleBtn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
            }
            .frame(width: 266, height: 40, alignment: .top) // ← 기존 폭 유지
            .padding(.top, 4)

            // 배너
            Image("umcPoster")
                .resizable()
                .scaledToFit() // 가로폭에 맞춰 자동 비율
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.vertical, 12)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)   // 좌우 16
        .padding(.bottom, 91)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview { LoginView() }
