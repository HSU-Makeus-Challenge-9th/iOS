//
//  ProfileDetailView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/27/25.
//

import Foundation
import SwiftUI

//struct ProfileDetailView: View {
//    var body: some View {
//        VStack(alignment:.center){
//            navigationBarTitle
//
////            userInformation
//            Text("name")
//            Text("id")
//        }.padding(.horizontal,20)
//
//    }
//
//    private var navigationBarTitle: some View {
//        HStack{
//            Text("<<")
//                .font(.largeTitle)
//                .foregroundColor(.primary)
//            Spacer()
//            Text("profile")
//            Spacer()
//        }.frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .center)
//    }
//}

struct ProfileDetailView: View {
    
    @Bindable var viewModel:LoginViewModel
    @AppStorage("ID") private var userID: String = "Default"
    private var customHeader: some View {
        HStack {
            Button {
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 18)
                    .foregroundColor(.black)
            }
            .padding(.trailing, 20)
            
            Spacer()
            
            Text("회원정보 관리")
                .font(.pretend(type: .medium, size: 18))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.black)
            
            Spacer()
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 12 + 20, height: 18)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            customHeader
            
                .padding(.bottom, 26)
            
            VStack(alignment: .leading, spacing: 26) {
                Text("기본정보")
                    .font(.pretend(type: .bold, size: 24))
                
                VStack(spacing: 0){
                    HStack{
//                        Text(viewModel.userIDInput)
                        Text(userID)
                            .frame(maxWidth: .infinity, alignment:.leading)
                            .font(.pretend(type: .medium, size: 16))
                            .foregroundStyle(Color.black)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .top)
                    Divider()
                    
                    HStack{
                        Text(viewModel.userName)
                            .frame(maxWidth: .infinity, alignment:.leading)
                            .font(.pretend(type: .medium, size: 16))
                            .foregroundStyle(Color.black)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .top)
                    Divider()
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}
#Preview {
    ProfileDetailView(viewModel: LoginViewModel())
}
