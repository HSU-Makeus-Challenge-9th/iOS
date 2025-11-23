//
//  ReusableComponents.swift
//  MegaBox
//
//  Created by 전효빈 on 11/23/25.
//

import Foundation
import SwiftUI

// MARK: 극장변경 컴퍼넌트
struct TheaterChangeBarView: View {
    let selectedTheaterName :String
    let action : () -> Void
    
    var body : some View {
        HStack{
            HStack{
                Image(systemName: "pin")
                    .frame(width:27, height:27)
                Text(selectedTheaterName)
                    .font(.pretend(type: .semiBold, size: 15))
            }
            .padding(0)
            .frame(width: 86)
            
            Spacer()
            
            HStack{
                Button(action: action) {
                    Text("극장변경")
                        .font(.pretend(type: .semiBold, size: 13))                }
            }
            .padding(0)
            .frame(width: 65, height: 36, alignment: .center)
            .cornerRadius(5)
            .overlay(
            RoundedRectangle(cornerRadius: 5)
            .inset(by: 0.5)
            .stroke(Color(red: 0.95, green: 0.95, blue: 0.95), lineWidth: 1)
            )
        }
        .padding(.vertical,10)
        .padding(.horizontal,20)
    }
}

//MARK: 메뉴아이템 컴포넌트
struct MenuItemView: View {
    let item : MenuItemModel
    
    var body: some View {
        VStack(alignment:.leading,spacing:12) {
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(width:152, height: 152)
                .background{
                    Image(item.menuImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:152)
                        .clipped()
                        .soldOutOverlay(isSoldOut: item.itemIsSoldOut)
                }
            VStack{
                Text(item.menuTitle)
                    .font(.pretend(type: .regular, size: 14))
                    .foregroundStyle(Color.black)
                Text("\(item.menuPrice)원")
                    .font(.pretend(type: .semiBold, size: 14))
                    .foregroundStyle(Color.black)
            }
        }
        .padding(.horizontal, 3)
        .padding(.vertical, 4)
        .frame(width: 152 , alignment: .center)
    }
}


