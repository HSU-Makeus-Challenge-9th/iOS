//
//  UserInfoView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 9/26/25.
//


import SwiftUI

struct UserInfoView: View
{
    @Binding var path: NavigationPath
//    @AppStorage("userId") private var userId: String = "zero"
//    @AppStorage("userName") private var userName: String = "sumini"
    @EnvironmentObject var loginModel: LoginViewModel  // <- 로그인 상태 공유
    @State private var tempUserName: String = ""
    @State private var showProfileSettings = false
    
    var body: some View{
            VStack{
                HStack(alignment: .center){//헤더
                    VStack{
                        HStack(alignment: .center){
                            Text("\(loginModel.userName)님")
                                .font(.bold24)
                                .foregroundStyle(Color("black"))
                                .frame(height: 36, alignment: .center)
                            Text("WELCOME")
                                .font(.medium14)
                                .foregroundStyle(Color("white"))
                                .background(Color("tag"))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .frame(maxWidth: 81, maxHeight: 25)
                            Spacer()
                            Button(action: {
                                showProfileSettings = true
                            }) {
                                Text("회원정보")
                                    .frame(alignment: .center)
                                    .font(.semiBold14)
                                    .foregroundStyle(Color("white"))
                            }
                            .sheet(isPresented: $showProfileSettings){
                                ProfileSettingsView(path: $path)
                                    .environmentObject(loginModel)
                            }
                            .frame(maxWidth: 72, maxHeight: 28)
                            .background(Color("gray07"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                        }
                        HStack{
                            Text("멤버십 포인트")
                                .font(.semiBold14)
                                .foregroundStyle(Color("gray04"))
                                .frame(height: 36, alignment: .center)
                            Text("500P")
                                .font(.medium14)
                                .foregroundStyle(Color("black"))
                                .frame(height: 36, alignment: .center)
                            Spacer()
                        }
                    }
                }
                Button(action: {}) {
                    Text("클럽 멤버십")
                        .padding(8)
                        .font(.semiBold16)
                        .foregroundStyle(Color("white"))
                    Image("chevron.right")
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 46)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("purple02"), Color("blue03")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                UserStateView()
                BookingView()
                Spacer()
            }
            .padding(10)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                tempUserName = loginModel.userName
            }
        }
    }
    
    private func makeChevron(name: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: name)
                .resizable()
                .frame(width: 17.47, height: 29.73)
        })
    }
    
    struct UserStateView: View
    {
        var body: some View
        {
            HStack(){
                VStack{
                    Text("쿠폰")
                        .font(.semiBold16)
                        .foregroundStyle(Color("gray02"))
                        .frame(height: 22, alignment: .center)
                    Text("0")
                        .font(.semiBold16)
                        .foregroundStyle(Color("black"))
                        .frame(height: 12, alignment: .center)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity,maxHeight: 76)
                
                Divider()
                    .frame(height: 31)
                VStack{
                    Text("스토어 교환권")
                        .font(.semiBold16)
                        .foregroundStyle(Color("gray02"))
                        .frame(height: 22, alignment: .center)
                    Text("0")
                        .font(.semiBold16)
                        .foregroundStyle(Color("black"))
                        .frame(height: 12, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 31)
                VStack{
                    Text("모바일 티켓")
                        .font(.semiBold16)
                        .foregroundStyle(Color("gray02"))
                        .frame(height: 22, alignment: .center)
                    Text("0")
                        .font(.semiBold16)
                        .foregroundStyle(Color("black"))
                        .frame(height: 12, alignment: .center)
                }
                .frame(maxWidth: .infinity,maxHeight: 76)
            }
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color("gray02"), lineWidth: 1)
            )
        }
    }
    
    struct BookingView: View
    {
        var body: some View
        {
            HStack(){
                VStack{
                    Image("movie")
                    Text("영화별예매")
                        .font(.medium16)
                        .foregroundStyle(Color("black"))
                        .frame(height: 19, alignment: .center)
                }
                Spacer()
                VStack{
                    Image("cinema")
                    Text("영화별예매")
                        .font(.medium16)
                        .foregroundStyle(Color("black"))
                        .frame(height: 19, alignment: .center)
                }
                Spacer()
                VStack{
                    Image("special")
                    Text("영화별예매")
                        .font(.medium16)
                        .foregroundStyle(Color("black"))
                        .frame(height: 19, alignment: .center)
                }
                Spacer()
                VStack{
                    Image("mobileOrder")
                    Text("영화별예매")
                        .font(.medium16)
                        .foregroundStyle(Color("black"))
                        .frame(height: 19, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity,maxHeight: 67)
        }
    }
    
    
    
    
    //#Preview {
    //    UserInfoView()
    //}
    
    //struct UserInfoView_Preview: PreviewProvider {
    //    static var previews: some View {
    //        devicePreviews {
    //            UserInfoView()
    //        }
    //    }
    //}
