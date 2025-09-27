//
//  ProfileView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/27/25.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    //    @Environment var sessionManager: UserSessionManager
    @Bindable var viewModel: LoginViewModel
    var body: some View {
        
        
        VStack(alignment: .leading,spacing:33){
            VStack(alignment:.leading){
                //                if let user : UserModel = sessionManager.currentUser{
                //                    userInformation(user:user)
                //                }
                userInformation
                membershipPoint
            }
            clubMembership
            customerStatus
            bottomImage
        }.frame(alignment:.topLeading)
            .padding(16)
        Spacer()
    }
    
    private var userInformation : some View{
        HStack{
            Group{
                Text("\(viewModel.userName)")
                    .font(.pretend(type: .bold, size: 24))
                Text("\(viewModel.membership)")
                    .font(.pretend(type:.medium, size:14))
                Spacer()
                Text("Info") // button 처리
            }.padding(.horizontal,10)
                .padding(.top,15)
        }
    }
    
    private var membershipPoint: some View {
        HStack{
            Text("멤버십 포인트")
                .font(.pretend(type:.semiBold, size:14))
                .padding(.horizontal,10)
                .padding(.top,15)
            Text(String(viewModel.membershipPoints) + "P")
                .font(.pretend(type:.medium, size:14))
                .padding(.top,15)
            Spacer()
        }
    }
    
    private var clubMembership: some View {
        VStack{
            Text("클럽 멤버십")// 버튼
        }.padding(.horizontal, 10)
            .font(.pretend(type: .semiBold, size: 16))
        
    }
    
    private var customerStatus: some View {
        HStack(alignment: .center, spacing: 20) {
            
            VStack(spacing: 10) {
                Text("쿠폰")
                    .font(.pretend(type: .semiBold, size: 16))
                    .foregroundColor(Color(red: 0.84, green: 0.84, blue: 0.84))
                Text("2")
                    .font(.pretend(type: .semiBold, size: 18))
                    .foregroundStyle(Color.black)
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 1, height: 31)
                .background(Color(red: 0.84, green: 0.84, blue: 0.84))
            
            VStack(spacing: 10) {
                Text("스토어 교환권")
                    .font(.pretend(type: .semiBold, size: 16))
                    .foregroundColor(Color(red: 0.84, green: 0.84, blue: 0.84))
                Text("0")
                    .font(.pretend(type: .semiBold, size: 18))
                    .foregroundStyle(Color.black)
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 1, height: 31)
                .background(Color(red: 0.84, green: 0.84, blue: 0.84))
            
            VStack(spacing: 10) {
                Text("모바일 티켓")
                    .font(.pretend(type: .semiBold, size: 16))
                    .foregroundColor(Color(red: 0.84, green: 0.84, blue: 0.84))
                Text("0")
                    .font(.pretend(type: .semiBold, size: 18))
                    .foregroundStyle(Color.black)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(Color(red: 0.84, green: 0.84, blue: 0.84), lineWidth: 1)
        )
    }//Vstack으로 묶은거 HStack으로 다시 풀어서 패딩 주기
    
    private var bottomImage: some View {
        HStack{
            VStack{
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 36, height: 36)
                        .background(
                            Image("PATH_TO_IMAGE")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipped()
                        )
                }
                .padding(0)
                .frame(width: 36, height: 36, alignment: .center)
                HStack(alignment: .center, spacing: 0) {
                    Text("영화별예매")
                        .font(.pretend(type:.medium,size:16))
                }
                .padding(0)
                .frame(width: 66, height: 19, alignment: .center)
                .overlay(
                Rectangle()
                .inset(by: 0.5)
                .stroke(.black, lineWidth: 1)

                )
            }.frame(width:66, height:67)
            Spacer()
            VStack{
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 36, height: 36)
                        .background(
                            Image("PATH_TO_IMAGE")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipped()
                        )
                }
                .padding(0)
                .frame(width: 36, height: 36, alignment: .center)
                HStack(alignment: .center, spacing: 0) {
                    Text("극장별예매")
                        .font(.pretend(type:.medium,size:16))
                }
                .padding(0)
                .frame(width: 66, height: 19, alignment: .center)
                .overlay(
                Rectangle()
                .inset(by: 0.5)
                .stroke(.black, lineWidth: 1)

                )
            }.frame(width:66, height:67)
            Spacer()
            VStack{
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 36, height: 36)
                        .background(
                            Image("PATH_TO_IMAGE")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipped()
                        )
                }
                .padding(0)
                .frame(width: 36, height: 36, alignment: .center)
                HStack(alignment: .center, spacing: 0) {
                    Text("특별관예매")
                        .font(.pretend(type:.medium,size:16))
                }
                .padding(0)
                .frame(width: 66, height: 19, alignment: .center)
                .overlay(
                Rectangle()
                .inset(by: 0.5)
                .stroke(.black, lineWidth: 1)

                )
            }.frame(width:66, height:67)
            Spacer()
            VStack{
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 36, height: 36)
                        .background(
                            Image("PATH_TO_IMAGE")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipped()
                        )
                }
                .padding(0)
                .frame(width: 36, height: 36, alignment: .center)
                HStack(alignment: .center, spacing: 0) {
                    Text("모바일오더")
                        .font(.pretend(type:.medium,size:16))
                }
                .padding(0)
                .frame(width: 66, height: 19, alignment: .center)
                .overlay(
                Rectangle()
                .inset(by: 0.5)
                .stroke(.black, lineWidth: 1)

                )
            }.frame(width:66, height:67)
        }
    }
}

#Preview {
    ProfileView(viewModel:LoginViewModel())
}
