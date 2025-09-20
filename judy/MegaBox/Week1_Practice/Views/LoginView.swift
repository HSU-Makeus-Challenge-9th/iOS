import SwiftUI

struct LoginView: View {
    @State private var userId: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // 페이지 상단 타이틀
                    HStack {
                        Spacer()
                        Text("로그인")
                            .font(.pretend(type: .semibold, size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 16)

                    // 아이디/비밀번호 입력 칸
                    VStack(alignment: .leading, spacing: 16) {

                        VStack(alignment: .leading, spacing: 8) {
                            TextField("아이디", text: $userId)
                                .textFieldStyle(.plain)
                                .font(.pretend(type: .regular, size: 16))
                                .foregroundColor(Color("grey03"))
                            Divider()
                                .background(Color("grey02"))
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            SecureField("비밀번호", text: $password)
                                .textFieldStyle(.plain)
                                .font(.pretend(type: .regular, size: 16))
                                .foregroundColor(Color("grey03"))
                            Divider()
                                .background(Color("grey02"))
                        }
                    }

                    // 로그인 버튼
                    Button {
                    } label: {
                        Text("로그인")
                            .font(.pretend(type: .bold, size: 17))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .buttonStyle(.plain)
                    .background(Color("purple03"))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.black.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(radius: 6, y: 3)

                    // 회원가입 텍스트
                    Text("회원가입")
                        .font(.pretend(type: .regular, size: 12))
                        .foregroundColor(Color("grey04"))
                        .padding(.top, 4)

                    // 소셜 로그인 버튼
                    HStack(alignment: .center, spacing: 0) {
                        Image("naverBtn")
                            .resizable().scaledToFit()
                            .frame(width: 40, height: 40)

                        Spacer().frame(width: 16)

                        Image("kakaoBtn")
                            .resizable().scaledToFit()
                            .frame(width: 40, height: 40)

                        Spacer().frame(width: 16)

                        Image("appleBtn")
                            .resizable().scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    .padding(.top, 4)

                    // UMC 배너
                    Rectangle()
                        .foregroundColor(.clear)
                        .aspectRatio(408.0/266.0, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .background(
                            Image("umcPoster")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        )
                }
                .padding(.horizontal, 16)  // 좌우 16 여백
                .padding(.bottom, 91)      // 하단 91 여백
            }
        }
    }
}

#Preview { LoginView() }
