//
//  HomeView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/1/25.
//

import SwiftUI

struct HomeView: View
{
    //    @Binding var path: NavigationPath
    var body: some View
    {
        
        VStack{
            HStack{
                Image("meboxLogo1")
                    .frame(width: 149,height: 30)
                Spacer()
            }
            HStack{
                Text("홈")
                    .font(.semiBold24)
                    .foregroundStyle(Color("black"))
                    .padding(.trailing, 31)
                Text("이벤트")
                    .font(.semiBold24)
                    .foregroundStyle(Color("gray04"))
                    .padding(.trailing, 31)
                Text("스토어")
                    .font(.semiBold24)
                    .foregroundStyle(Color("gray04"))
                    .padding(.trailing, 31)
                Text("선호극장")
                    .font(.semiBold24)
                    .foregroundStyle(Color("gray04"))
                Spacer()
            }
            HStack{
                Button(action: {
                    
                }) {
                    Text("무비차트")
                        .frame(alignment: .center)
                        .font(.medium14)
                        .foregroundStyle(Color("white"))
                }
                .frame(maxWidth: 84, maxHeight: 38)
                .background(Color("gray08"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Button(action: {
                    
                }) {
                    Text("상영예정")
                        .frame(alignment: .center)
                        .font(.medium14)
                        .foregroundStyle(Color("gray04"))
                }
                .frame(maxWidth: 84, maxHeight: 38)
                .background(Color("gray02"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                
            }
            MovieView()
            Spacer()
        }
        .padding(10)
    }
}

#Preview {
    HomeView()
}
