//
//  ProfileSettingsView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 9/26/25.
//



import SwiftUI

struct ProfileSettingsView: View
{
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    @AppStorage("userId") private var userId: String = "zero"
    
    @AppStorage("userName") private var userName: String = "sumini"
    
    @State private var tempUserName: String = ""
    
    var body: some View
    {
        VStack(spacing: 53){
            HStack{
                Button(action: {
                    if !path.isEmpty {
                            path.removeLast()
                        } else {
                            dismiss()
                        }
                    print("\(path)")
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color("black"))
                }
                Spacer()
                Text("회원정보 관리")
                    .font(.medium16)
                    .foregroundStyle(Color("black"))
                Spacer()
            }
            
            Text("기본정보")
                .font(.bold18)
                .foregroundStyle(Color("black"))
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(){
                Text(userId)//회원 아이디
                    .font(.medium18)
                    .foregroundStyle(Color("black"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                    .foregroundStyle(Color("gray02"))
                
                HStack{
                    TextField("\(userName)", text: $tempUserName)//회원 이름
                        .font(.medium18)
                        .foregroundStyle(Color("black"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {
                        userName = tempUserName
                    }) {
                        Text("변경")
                            .frame(alignment: .center)
                            .font(.medium10)
                            .foregroundStyle(Color("gray03"))
                    }
                    .frame(maxWidth: 38, maxHeight: 20)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("gray03"), lineWidth: 1)
                    )
                    
                }
                Divider()
                    .foregroundStyle(Color("gray02"))
            }
            Spacer()
        }
        .padding(10)
        .navigationBarBackButtonHidden(true)
    }
}
    


//
//#Preview {
//    ProfileSettingsView()
//}

//struct ProfileSettingView_Preview: PreviewProvider {
//    static var previews: some View {
//        devicePreviews {
//            ProfileSettingsView()
//        }
//    }
//}
