//
//  MovileOrderView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/19/25.
//

    import SwiftUI

struct MobileOrderView: View {
    var body: some View {
        VStack{
            HStack{
                Image("meboxLogo")
                    .frame(width: 149, height: 30)
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 17)
                Spacer()
            }
            TheaterBar(location:"홍대", backgroundColor: Color("blue03"))
            HStack{
                Text("추천 메뉴")
                    .font(.bold22)
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                Spacer()
            }
            HStack{
                Text("영화 볼 때 뭐먹지 고민될 땐 추천 메뉴!")
                    .font(.regular12)
                    .foregroundColor(Color("gray03"))
                    .padding(.leading, 20)
                    .padding(.top,10)
                Spacer()
            }
            .padding(.bottom, 20)
            MenuCard(menu: MenuItemModel.love.returnMenu())
        }
    }
}

#Preview {
    MobileOrderView()
}
