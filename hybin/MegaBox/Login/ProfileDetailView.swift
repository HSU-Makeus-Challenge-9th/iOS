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
    @State var isNameEditing: Bool = false
    @AppStorage("ID") private var userID: String = "Default"
    @AppStorage("Name") private var userName: String = "Default"
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
                        if isNameEditing {
                            TextField("이름 입력", text: $userName)
                                .textFieldStyle(.roundedBorder)
                                .font(.system(size: 16, weight: .medium))
                        } else {
                            Text(userName)
                                .frame(maxWidth: .infinity, alignment:.leading)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if isNameEditing == true {
                                isNameEditing = false
                            } else {isNameEditing = true}
                        }, label: {
                            Text(isNameEditing ? "저장": "변경")
                                .font(.pretend(type:.semiBold,size:16))
                                .padding(5)
                                .foregroundStyle(Color.gray)
                                .clipShape(Capsule())
                                .backgroundStyle(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        })
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
