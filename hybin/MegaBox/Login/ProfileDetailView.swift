//
//  ProfileDetailView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/27/25.
//

import Foundation
import SwiftUI

struct ProfileDetailView: View {
    
    @Environment(UserSessionManager.self) var usm : UserSessionManager
    @Environment(\.dismiss) private var dismiss
    @State var isNameEditing: Bool = false
    @State var tempName : String = ""
    
//    private var customHeader: some View {
//        HStack {
//            Button {
//                dismiss()
//            } label: {
//                Image(systemName: "chevron.left")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 12, height: 18)
//                    .foregroundStyle(Color.black)
//            }
//            .padding(.trailing, 20)
//            
//            Spacer()
//            
//            Text("회원정보 관리")
//                .font(.pretend(type: .medium, size: 18))
//                .multilineTextAlignment(.center)
//                .foregroundStyle(Color.black)
//            
//            Spacer()
//            
//            Rectangle()
//                .fill(Color.clear)
//                .frame(width: 12 + 20, height: 18)
//        }
//        .padding(.horizontal, 20)
//        .padding(.top, 10)
//    }
    //SwiftUI 내장 네비게이션 UI 사용
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 26) {
                Text("기본정보")
                    .font(.pretend(type: .bold, size: 24))
                
                VStack(spacing: 0){
                    HStack{
                        Text(usm.currentUser?.userId ?? "")
                            .frame(maxWidth: .infinity, alignment:.leading)
                            .font(.pretend(type: .medium, size: 16))
                            .foregroundStyle(Color.black)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .top)
                    Divider()
                    
                    HStack{
                        if isNameEditing {
                            TextField("이름 입력", text: $tempName)
                                .textFieldStyle(.roundedBorder)
                                .font(.system(size: 16, weight: .medium))
                        } else {
                            Text(usm.currentUser?.userName ?? "")
                                .frame(maxWidth: .infinity, alignment:.leading)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if isNameEditing == true {
                                usm.updateUserName(editName: tempName)
                                isNameEditing = false
                            } else {
                                tempName = usm.currentUser?.userName ?? ""
                                isNameEditing = true
                            }
                        }, label: {
                            Text(isNameEditing ? "저장": "변경")
                                .font(.pretend(type:.semiBold,size:16))
                                .padding(5)
                                .foregroundStyle(Color.gray)
                                .backgroundStyle(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius:8))
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
        .navigationTitle("회원 정보")
    }
}
#Preview {
    NavigationStack{
        ProfileDetailView()
            .environment(UserSessionManager())
    }
}
