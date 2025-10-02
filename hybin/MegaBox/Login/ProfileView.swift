//
//  ProfileView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/27/25.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    
    @Environment(UserSessionManager.self) var usm : UserSessionManager
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading,spacing:33){
                VStack(alignment:.leading){
                    
                    userInformation
                    membershipPoint
                        .padding(.bottom ,15)
                    clubMembership
                }
                customerStatus
                bottomImage
            }.frame(alignment:.topLeading)
                .padding(.top, 20)
                .padding(.horizontal, 15)
            Spacer()
        }
    }
    
    private var userInformation : some View{
        HStack{
            Group{
                Text(usm.currentUser?.userName ?? "" + "님")
                    .font(.pretend(type: .bold, size: 24))
                Text(usm.currentUser?.membership.rawValue ?? "")
                    .font(.pretend(type:.medium, size:14))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.28, green: 0.8, blue: 0.82))
                
                    .cornerRadius(6)
                Spacer()
                
                NavigationLink(destination: ProfileDetailView().environment(usm)){
                    Text("회원정보")
                        .font(.pretend(type:.semiBold, size:14))
                        .foregroundStyle(Color.white)
                        .padding(4)
                        .frame(width: 72, alignment: .center)
                        .background(Color(red: 0.28, green: 0.28, blue: 0.28))
                    
                        .clipShape(RoundedRectangle(cornerRadius: 16)) //button 처리
                }
            }.padding(0)
        }
    }
    
    private var membershipPoint: some View {
        HStack{
            Text("멤버십 포인트")
                .font(.pretend(type:.semiBold, size:14))
                .padding(.horizontal,10)
                .padding(.top,15)
            Text(String(usm.currentUser?.membershipPoints ?? 0) + "P")
                .font(.pretend(type:.medium, size:14))
                .padding(.top,15)
            Spacer()
        }
    }
    
    private var clubMembership: some View {
        HStack(alignment: .center, spacing: 3) {
            Text("클럽 멤버십")
                .font(.pretend(type:.semiBold,size:16))
                .multilineTextAlignment(.trailing)
                .foregroundColor(.white)
            
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(.white)
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
                    .font(.pretend(type: .semiBold, size: 14))
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
                            Image(.flim)
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
                        .font(.pretend(type:.medium,size:14))
                }
                .padding(0)
                .frame(width: 66, height: 19, alignment: .center)
                
            }.frame(width:66, height:67)
            Spacer()
            VStack{
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 36, height: 36)
                        .background(
                            Image(.locate)
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
                        .font(.pretend(type:.medium,size:14))
                }
                .padding(0)
                .frame(width: 66, height: 19, alignment: .center)
                
            }.frame(width:66, height:67)
            Spacer()
            VStack{
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 36, height: 36)
                        .background(
                            Image(.sofa)
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
                        .font(.pretend(type:.medium,size:14))
                }
                .padding(0)
                .frame(width: 66, height: 19, alignment: .center)
            }.frame(width:66, height:67)
            Spacer()
            VStack{
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 36, height: 36)
                        .background(
                            Image(.popcorn)
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
                        .font(.pretend(type:.medium,size:14))
                }
                .padding(0)
                .frame(width: 66, height: 19, alignment: .center)
            }.frame(width:66, height:67)
        }
    }
}

#Preview {
    ProfileView()
        .environment(UserSessionManager())
}
