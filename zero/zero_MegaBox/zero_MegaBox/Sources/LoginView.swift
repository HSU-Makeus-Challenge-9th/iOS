//
//  LoginView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 9/18/25.
//

import SwiftUI

struct LoginView: View
{
    var body: some View
    {
        VStack{
            
            HStack(alignment: .center){
                Text("로그인")
                    .font(.semiBold24)
                    .foregroundStyle(Color("black"))
                    .frame(height: 36, alignment: .center)
                
            }
            VStack{
                
                Spacer()
                Text("아이디")
                    .font(.medium16)
                    .foregroundStyle(Color("gray03"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                
                Spacer()
                Text("비밀번호")
                    .font(.medium16)
                    .foregroundStyle(Color("gray03"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                
                Spacer()
                Button(action: {
                }) {
                    Text("로그인")
                        .frame(alignment: .center)
                        .font(.bold18)
                        .foregroundStyle(Color("white"))
                }
                .frame(maxWidth: .infinity, maxHeight: 54)
                .background(Color("purple03"))
                .cornerRadius(10)
                
                Text("회원가입")
                    .font(.medium13)
                    .frame(maxHeight: 16)
                    .foregroundColor(Color("gray04"))
                Spacer()
                HStack{
                    Spacer()
                    Image("naver")
                    Spacer()
                    Image("kakao")
                    Spacer()
                    Image("apple")
                    Spacer()
                }
                Spacer()
                Image("umc 1")
                    .resizable()
                    .frame(maxWidth: 408, maxHeight: 266)
        }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
    }
}
//#Preview {
//    LoginView()
//}

enum PREVIEW_DEVICE_TYPE : String, CaseIterable {
    case iPhone_16_Pro_Max = "iPhone 16 Pro Max"
    case iPhone_11 = "iPhone 11"
    
    var previewDevice: PreviewDevice {
        .init(rawValue: self.rawValue)
    }
}

func devicePreviews<Content: View>(
    content: @escaping () -> Content
) -> some View {
    ForEach(PREVIEW_DEVICE_TYPE.allCases, id: \.self) { device in
        content()
            .previewDevice(device.previewDevice)
            .previewDisplayName(device.rawValue)
    }
}

struct SwiftUIView_Preview: PreviewProvider {
    static var previews: some View {
        devicePreviews {
            LoginView()
        }
    }
}
