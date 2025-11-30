////
////  ProfileView.swift
////  MegaBox
////
////  Created by 전효빈 on 9/27/25.
////


import Foundation
import SwiftUI

struct ProfileView: View {
    
    // 환경 객체 주입
    @Environment(UserSessionManager.self) var usm : UserSessionManager
    @State private var profileImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    
    var body: some View {
        NavigationStack{
            
            ScrollView {
                VStack(alignment: .leading,spacing:33){
                    
                    VStack(alignment:.leading){
                        
                        if let user = usm.currentUser{
                            userInformation(user: user)
                            //                            logoutButton
                        } else {
                            // 로그아웃 상태일 때 대체 UI
                            Text("로그인 상태가 아닙니다.").font(.title).padding(.leading, 10)
                        }
                        
                        clubMembership
                            .padding(.top , 15)
                    }
                    
                    customerStatus
                    bottomImage
                    
                    
                }
                
                .padding(.top, 20)
                .padding(.horizontal, 15)
            }
        }
    }
    
    //로그아웃버튼
    private var logoutButton: some View {
        ZStack{
            Button("로그아웃"){
                usm.logout()
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 10)
        }
    }
    
    // 사용자 정보 (이름, 등급, 회원정보 버튼 포함)
    private func userInformation(user : User) -> some View{
        HStack{
            
            VStack {
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                } else {
                    Image("gg_profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                }
            }
            .onLongPressGesture(minimumDuration: 1.0) {
                print("press.")
                isImagePickerPresented = true
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $profileImage)
            }
            
            VStack(spacing: 0){
                HStack{
                    
                    Text(user.name + "님")
                        .font(.pretend(type: .bold, size: 24))
                    
                    Text(user.membership.rawValue)
                        .font(.pretend(type:.medium, size:14))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.28, green: 0.8, blue: 0.82))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    Spacer() // 오른쪽 버튼 밀어내기
                    
                    // 회원정보 관리 NavigationLink
                    NavigationLink(destination: ProfileDetailView()){
                        Text("회원정보")
                            .font(.pretend(type:.semiBold, size:14))
                            .foregroundStyle(Color.white)
                            .padding(4)
                            .frame(width: 72, alignment: .center)
                            .background(Color(red: 0.28, green: 0.28, blue: 0.28))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(0)
                
                HStack{
                    Text("멤버십 포인트")
                        .font(.pretend(type:.semiBold, size:14))
                        .padding(.horizontal,10)
                        .padding(.top,15)
                    
                    Text(String(user.membershipPoints) + "P")
                        .font(.pretend(type:.medium, size:14))
                        .padding(.top,15)
                    Spacer()
                }
            }
        }
    }
    
    //    // 멤버십 포인트 정보
    //    private func membershipPoint(user:User) -> some View {
    //        HStack{
    //            Text("멤버십 포인트")
    //                .font(.pretend(type:.semiBold, size:14))
    //                .padding(.horizontal,10)
    //                .padding(.top,15)
    //
    //            Text(String(user.membershipPoints) + "P")
    //                .font(.pretend(type:.medium, size:14))
    //                .padding(.top,15)
    //            Spacer()
    //        }
    //    }
    
    
    
    private var clubMembership: some View {
        HStack(alignment: .center, spacing: 3) {
            Text("클럽 멤버십")
                .font(.pretend(type:.semiBold,size:16))
                .multilineTextAlignment(.trailing)
                .foregroundStyle(Color.white)
            
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundStyle(Color.white)
        }
        .padding(.leading, 8)
        .padding(.trailing, 30)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.67, green: 0.55, blue: 1), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.56, green: 0.68, blue: 0.95), location: 0.53),
                    Gradient.Stop(color: Color(red: 0.36, green: 0.8, blue: 0.93), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0, y: 0.5),
                endPoint: UnitPoint(x: 1, y: 0.5)
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var customerStatus: some View {
        HStack(alignment: .center, spacing: 20) {
            // 쿠폰
            VStack(spacing: 10) {
                Text("쿠폰")
                    .font(.pretend(type: .semiBold, size: 16))
                    .foregroundStyle(Color.loginTextBackgroundColor)
                Text("2")
                    .font(.pretend(type: .semiBold, size: 18))
                    .foregroundStyle(Color.black)
            }.frame(maxWidth: .infinity)
            
            // 구분선
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(width: 1, height: 31)
                .background(Color(red: 0.84, green: 0.84, blue: 0.84))
            
            // 스토어 교환권
            VStack(spacing: 10) {
                Text("스토어 교환권")
                    .font(.pretend(type: .semiBold, size: 14))
                    .foregroundStyle(Color.loginTextBackgroundColor)
                Text("0")
                    .font(.pretend(type: .semiBold, size: 18))
                    .foregroundStyle(Color.black)
            }.frame(maxWidth: .infinity)
            
            // 구분선
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(width: 1, height: 31)
                .background(Color(red: 0.84, green: 0.84, blue: 0.84))
            
            // 모바일 티켓
            VStack(spacing: 10) {
                Text("모바일 티켓")
                    .font(.pretend(type: .semiBold, size: 16))
                    .foregroundStyle(Color.loginTextBackgroundColor)
                Text("0")
                    .font(.pretend(type: .semiBold, size: 18))
                    .foregroundStyle(Color.black)
            }.frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(Color(red: 0.84, green: 0.84, blue: 0.84), lineWidth: 1)
        )
    }
    
    private var bottomImage: some View {
        HStack{
            // 영화별예매
            VStack{
                Image(.flim)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .clipped()
                HStack(alignment: .center, spacing: 0) {
                    Text("영화별예매")
                        .font(.pretend(type:.medium,size:14))
                }
            }.frame(width:66, height:67)
                .padding(.horizontal, 10) // 중앙 정렬을 위해 padding 추가
            
            Spacer()
            
            // 극장별예매
            VStack{
                Image(.locate)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .clipped()
                HStack(alignment: .center, spacing: 0) {
                    Text("극장별예매")
                        .font(.pretend(type:.medium,size:14))
                }
            }.frame(width:66, height:67)
                .padding(.horizontal, 10)
            
            Spacer()
            
            // 특별관예매
            VStack{
                Image(.sofa)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .clipped()
                HStack(alignment: .center, spacing: 0) {
                    Text("특별관예매")
                        .font(.pretend(type:.medium,size:14))
                }
            }.frame(width:66, height:67)
                .padding(.horizontal, 10)
            
            Spacer()
            
            // 모바일오더
            VStack{
                Image(.popcorn)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .clipped()
                HStack(alignment: .center, spacing: 0) {
                    Text("모바일오더")
                        .font(.pretend(type:.medium,size:14))
                }
            }.frame(width:66, height:67)
                .padding(.horizontal, 10)
        }
        .padding(.horizontal, 5)
    }
}

#Preview {
    ProfileView()
        .environment(UserSessionManager())
}
