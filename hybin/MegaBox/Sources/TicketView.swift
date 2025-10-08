//
//  TicketView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/20/25.
//

import SwiftUI



struct TicketView: View{
    var body:some View{
        ZStack(){
            Image(.background).opacity(0.9)
            
            VStack(){
                Spacer().frame(height:111)
                mainTitleGroup
                Spacer().frame(height:134)
                mainBottomGroup
            }
            .padding(.horizontal, 76)
        }
    }
    
    private var mainTitleGroup :some View {
        VStack{
            Group{
                Text("마이펫의 이중생활2")
                    .font(.PretendardBold30)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text("본인 + 동반 1인")
                    .font(.PretendardLight26)
                Text("30,100원")
                    .font(.pretend(type: .bold, size: 14))
            }.foregroundStyle(Color.white)
        }.frame(height:84)
    }
    
    private var mainBottomGroup :some View {
        Button(action: {print("hello")}
               , label: {
            VStack {
                Image(systemName: "chevron.up")
                    .resizable()
                    .frame(width: 18, height: 12)
                    .foregroundStyle(Color.white)
                Text("예매하기")
                    .font(.pretend(type:.bold,size:18))
                    .foregroundStyle(Color.white)
            }
            .frame(width: 63, height: 40)
        })
    }
    
}


#Preview() {
    TicketView()
}


