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
    
    var body: some View {
        VStack(spacing: 0) {
            if let user = usm.currentUser{
                VStack(alignment: .leading, spacing: 26) {
                    Text("기본정보")
                        .font(.pretend(type: .bold, size: 24))
                    
                    VStack(spacing: 0){
                        HStack{
                            Text(user.id)
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
                                Text(user.name)
                                    .frame(maxWidth: .infinity, alignment:.leading)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Color.black)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if isNameEditing == true {
                                    usm.updateUserName(newName: tempName)
                                    isNameEditing = false
                                } else {
                                    tempName = user.name
                                    isNameEditing = true
                                }
                            }, label: {
                                Text(isNameEditing ? "저장": "변경")
                                    .font(.pretend(type:.semiBold,size:16))
                                    .padding(5)
                                    .foregroundStyle(Color.gray)
                                    .background(Color.white)
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
