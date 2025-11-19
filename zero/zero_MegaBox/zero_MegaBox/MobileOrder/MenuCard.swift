//
//  MenuCard.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/19/25.
//

import SwiftUI

struct MenuCard: View {
    var menu: Menu
    var body: some View {
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
    }
}

#Preview {
    MenuCard(menu: MenuItemModel.love.returnMenu())
}
