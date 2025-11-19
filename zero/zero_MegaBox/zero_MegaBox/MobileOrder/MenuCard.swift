//
//  MenuCard.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/19/25.
//

import SwiftUI

struct MenuCard: View {
    var menu: Menu
    var isBest: Bool = false
    var isRecommend: Bool = false
    var soldOut: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading){
            VStack {
                Image(menu.image)
                    .frame(width: 152, height: 152)
                    .background(Color("gray01"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                HStack{
                    Text(menu.name)
                        .font(.regular13)
                        .foregroundColor(.black)
                    Spacer()
                }
                HStack{
                    Text(menu.price)
                        .font(.semiBold13)
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .frame(width: 158, height: 210)
            if isBest {
                Text("BEST")
                    .font(.semiBold12)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .cornerRadius(5)
                    .offset(x: 4, y: 12)
            }
            if isRecommend {
                Text("추천")
                    .font(.semiBold12)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .offset(x: 4, y: 12)
            }
            if soldOut {
                Text("품절")
                    .font(.semiBold12)
                    .foregroundColor(.white)
                    .padding(.horizontal, 65)
                    .padding(.vertical, 70)
                    .background(.black.opacity(0.8))
                    .cornerRadius(5)
                    .offset(x: 4, y: 12)
            }
        }
        
    }
}

#Preview {
    MenuCard(menu: MenuItemModel.loveCombo
        .returnMenu())
}
