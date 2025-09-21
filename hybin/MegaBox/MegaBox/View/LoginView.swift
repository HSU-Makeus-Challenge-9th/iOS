//
//  LoginView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/20/25.
//

import Foundation
import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack{
            NavigationBarTitle
            Spacer()
            VStack{
                Spacer()
                loginTextView
                    .padding(.vertical,50)
                loginButtonView
                    .padding(.vertical,30)
                socialLogin
            }
            
            Spacer().frame(height:39)
            UMCImage
        }
        .padding(.horizontal)
    }
}

private var NavigationBarTitle: some View {
    HStack{
        Text("로그인")
            .font(Font.pretend(type: .semiBold, size: 24))
            .frame(alignment: .center)
    }
}


private var loginTextView: some View {
    VStack(alignment : .center){
        Group{
            Text("아이디")
                .frame(maxWidth: .infinity,alignment:.leading)
                .font(.pretend(type: .light, size: 18))
                .foregroundStyle(Color.loginTextBackgroundColor)
            Divider()
            
            
            Text("비밀번호")
                .frame(maxWidth:.infinity,alignment: .leading)
                .font(.pretend(type: .light, size: 18))
                .foregroundStyle(Color.loginTextBackgroundColor)
            
            Divider()
        }
    }.padding(0)
}

private var loginButtonView: some View {
    VStack{
        Button(action: {print("login")},
               label:{
            Text("로그인")
                .font(.pretend(type: .bold, size: 18))
                .frame(maxWidth: .infinity,alignment: .center)
        })
        .buttonStyle(RoundedButtonStyle())
        
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

struct RoundedButtonStyle:ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.loginBackgroundColor)
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
    }
}



private var UMCImage: some View {
    VStack{
        Image(.umcLogo)
            .foregroundStyle(Color.clear)
            .frame(width: 408, height: 266)
            .clipped()
    }
}
#Preview {
    LoginView()
}
