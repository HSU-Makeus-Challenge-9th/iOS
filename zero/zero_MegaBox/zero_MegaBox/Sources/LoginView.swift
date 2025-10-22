//
//  LoginView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 9/18/25.
//

import SwiftUI

enum Route: Hashable, Equatable {
    case logined
    case home
    case profile
    case profileSettings
    case movieDetail(Movie)
}

struct LoginView: View
{
    @State private var loginModel = LoginViewModel()
    @State var path: NavigationPath = NavigationPath()
    @AppStorage("id") private var userId: String = ""
    @AppStorage("pwd") private var userPwd: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    
    var body: some View
    {
        NavigationStack(path: $path){
            VStack{
                HStack(alignment: .center){
                    Text("로그인")
                        .font(.semiBold24)
                        .foregroundStyle(Color("black"))
                        .frame(height: 36, alignment: .center)
                    
                }
                VStack{
                    Spacer()
                    
                    TextField("아이디", text: $loginModel.id)
                        .font(.medium16)
                        .foregroundStyle(Color("gray03"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    Spacer()
                    
                    SecureField("비밀번호", text: $loginModel.pwd)
                        .font(.medium16)
                        .foregroundStyle(Color("gray03"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    Spacer()
                    
                    Button(action: {
                        
                        if loginModel.id == userId && loginModel.pwd == userPwd {
                            isLoggedIn = true
                            print("로그인 성공")
                            path.append(Route.logined)
                        } else {
                            print("로그인 실패")
                        }
                    }) {
                        Text("로그인")
                            .frame(alignment: .center)
                            .font(.bold18)
                            .foregroundStyle(Color("white"))
                    }
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .background(Color("purple03"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .logined:
                            MainTabView(path: $path)
                        case .home:
                            HomeView(path: $path)
                        case .profile:
                            ProfileSettingsView(path: $path)
                        case .profileSettings:
                            ProfileSettingsView(path: $path)
                        case .movieDetail(let movie):
                            MovieDetailView(path: $path, movie: movie)
                        }
                    }
                    Text("회원가입")
                        .font(.medium13)
                        .frame(maxHeight: 16)
                        .foregroundStyle(Color("gray04"))
                    Spacer()
                    HStack{
                        Spacer()
                        Image("naver")
                        Spacer()
                        Image("kakao")
                        Spacer()
                        Image("apple")
                        Spacer()
                    }
                    Spacer()
                    Image("umcPoster")
                        .resizable()
                        .frame(maxWidth: 408, maxHeight: 266)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(10)
        }
    }
    
}
#Preview {
    LoginView(path: NavigationPath())
}

enum PREVIEW_DEVICE_TYPE : String, CaseIterable {
    case iPhone_16_Pro_Max = "iPhone 16 Pro Max"
    case iPhone_11 = "iPhone 11"
    
    var previewDevice: PreviewDevice {
        .init(rawValue: self.rawValue)
    }
}

func devicePreviews<Content: View>(
    content: @escaping () -> Content
) -> some View {
    ForEach(PREVIEW_DEVICE_TYPE.allCases, id: \.self) { device in
        content()
            .previewDevice(device.previewDevice)
            .previewDisplayName(device.rawValue)
    }
}

//struct SwiftUIView_Preview: PreviewProvider {
//    static var previews: some View {
//        devicePreviews {
//            LoginView()
//        }
//    }
//}

