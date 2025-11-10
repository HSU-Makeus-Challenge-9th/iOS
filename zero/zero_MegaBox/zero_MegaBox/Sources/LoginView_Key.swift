//
//  LoginView_Key.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/08/25.
//

import SwiftUI

struct LoginView_Key: View {
    @StateObject private var loginModel = LoginViewModel()
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        Group{
            if loginModel.isLoggedIn{
                NavigationStack(path: $path){
                    MainTabView(path: $path)
                        .environmentObject(loginModel)
                        .onAppear{
                            print("자동 로그인 성공 - 사용자 : \(loginModel.userName)")
                        }
                }
            }
            else{
                NavigationStack(path: $path) {
                    VStack {
                        HStack(alignment: .center) {
                            Text("로그인")
                                .font(.semiBold24)
                                .foregroundStyle(Color("black"))
                                .frame(height: 36, alignment: .center)
                        }
                        
                        VStack {
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
                                loginModel.login()
                                if loginModel.isLoggedIn {
                                    path.append(Route.logined)
                                } else {
                                    print("로그인 실패: 아이디 또는 비밀번호가 잘못되었습니다.")
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
                            .padding(.horizontal)
                            
                            Text("회원가입")
                                .font(.medium13)
                                .frame(maxHeight: 16)
                                .foregroundStyle(Color("gray04"))
                            
                            Spacer()
                            
                            HStack {
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
                    
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .logined:
                            MainTabView(path: $path)
                                .environmentObject(loginModel)
                        case .home:
                            HomeView(path: $path)
                        case .profile:
                            ProfileSettingsView(path: $path)
                                .environmentObject(loginModel)
                        case .profileSettings:
                            ProfileSettingsView(path: $path)
                                .environmentObject(loginModel)
                        case .movieDetail(let movie):
                            MovieDetailView(path: $path, movie: movie)
                        }
                    }
                    
                    .onAppear {
                        loginModel.autoLogin()
                        if loginModel.isLoggedIn {
                            path.append(Route.logined)
                        }
                    }
            }
        }
        
        
        
        
        }
        .environmentObject(loginModel)
    }
}
