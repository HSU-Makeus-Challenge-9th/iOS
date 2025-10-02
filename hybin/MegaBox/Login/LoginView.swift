//
//  LoginView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/20/25.
//

import Foundation
import SwiftUI
import Observation

struct LoginView: View {
    @State var viewModel: LoginViewModel = .init()
    
    @AppStorage("ID") private var userID: String = "?"
    @AppStorage("PWD") private var userPWD: String = "!"
    
    
    var body: some View {
        VStack{
            NavigationBarTitle
            Spacer()
            VStack{
                Spacer()
                Group{
                    loginTextView
                        .padding(.vertical,50)
                    loginButtonView
                        .padding(.vertical,30)
                    socialLogin
                    
                    Spacer().frame(height:39)
                    
                }
            }
            
            Spacer().frame(height:39)
            UMCImage
        }
        .padding(.horizontal)
    }
    
    private var loginTextView: some View {
        VStack(alignment : .center){
            
                TextField("아이디", text: $viewModel.userIDInput)
                    .frame(maxWidth: .infinity,alignment:.leading)
                    .font(.pretend(type: .medium, size: 16))
                    .foregroundStyle(Color.loginTextBackgroundColor)
                Divider()
                
                SecureField("비밀번호", text:$viewModel.passwordInput)
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .font(.pretend(type: .medium, size: 16))
                    .foregroundStyle(Color.loginTextBackgroundColor)
                
                Divider()
            
        }.padding(0)
    }
    
    private var NavigationBarTitle: some View {
        HStack{
            Text("로그인")
                .font(Font.pretend(type: .semiBold, size: 24))
                .frame(alignment: .center)
        }
        
    }
    
    private var loginButtonView: some View {
        VStack{
            Button(action: {
                print("login")
                userID = viewModel.userIDInput
                userPWD = viewModel.passwordInput
                print(userID + "/" + userPWD)
            },label:{
                Text("로그인")
                    .font(.pretend(type: .bold, size: 18))
                    .frame(maxWidth: .infinity,alignment: .center)
            })
            .foregroundStyle(Color.white)
            .padding()
            .background(Color.loginBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(maxWidth: .infinity)
            
            
            Text("회원가입")
                .font(.pretend(type: .medium, size: 12))
                .padding(0)
        }
    }
    
    private var socialLogin: some View {
        HStack{
            
            Image(.naverLogin)
            Spacer()
            Image(.kakaoLogin)
            Spacer()
            Image(.appleLogin)
            
        }.frame(width:266,height:40,alignment:.bottom)
    }
    
    
    
    
    private var UMCImage: some View {
        VStack{
            Image(.umcLogo)
                .resizable()
                .frame(height: 266)
            
        }
    }
    
}
#Preview {
    LoginView()
}
