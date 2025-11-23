//
//  OrderView.swift
//  MegaBox
//
//  Created by 전효빈 on 11/23/25.
//

import Foundation
import SwiftUI


struct OrderItemView: View {
    @State private var viewModel = OrderItemViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                ScrollView{
                    VStack(spacing: 0) {
                        Image(.megaBoxLogo)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        TheaterChangeBarView(
                            selectedTheaterName: "강남", action:{ print("hi")}
                        )
                        .newTheaterBar(newForegroundColor: .white, newBackgroundColor: .loginBackground)
                        .padding(.vertical, 10)
                        .frame(maxWidth:.infinity)
                        OrderItemButtonSection
                            .padding(.vertical, 15)
                        
                        RecommendItemSection
                        BestItemSection
                    }
                }
            }
        }
    }
    
    private var OrderItemButtonSection: some View {
        VStack(spacing: 20){
            
            HStack(alignment:.center , spacing: 15){
                NavigationLink {
                       OrderItemDetailView()
                    } label: {
                        MenuItemOrderButtonView(
                            title:"바로 주문",
                            description:"이제 줄서지 말고 \n모바일로 바로 픽업!",
                            symbol:"popcorn"
                        )
                    }
                VStack{
                    MenuItemOrderButtonView(title: "스토어 교환권", description: nil, symbol: "ticket")
                    MenuItemOrderButtonView(title: "선물하기", description: nil, symbol: "gift")
                }
            }
            HStack{
                VStack(spacing: 10){
                    Text("어디서든 팝콘 만나기")
                        .font(.pretend(type: .bold, size: 20))
                    Text("팝콘 콜라 스낵 모든 메뉴 배달 가능!")
                        .font(.pretend(type: .regular, size: 12))
                        .foregroundStyle(Color.loginTextBackground)
                }
                Spacer()
                Image(systemName: "motorcycle")
            }
            .padding(.horizontal,15)
            .padding(.vertical,25)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.79, green: 0.77, blue: 0.77), lineWidth: 1)
            )
        }
        .padding(.horizontal,20)
    }
    private var RecommendItemSection: some View {
        VStack(alignment: .leading, spacing: 10){
            itemSectionTitle(title: "추천 메뉴", description: "영화 볼 때 뭐먹지 고민될 땐 추천 메뉴!")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.menuItem.filter { $0.itemIsRecommend }) { item in
                        MenuItemView(item: item)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    private var BestItemSection : some View {
        VStack(alignment: .leading, spacing: 10){
            itemSectionTitle(title: "베스트 메뉴", description: "영화 볼 때 뭐먹지 고민될 땐 베스트 메뉴!")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.menuItem.filter { $0.itemIsBest }) { item in
                        MenuItemView(item: item)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    
    private func itemSectionTitle(title: String, description: String) -> some View{
        VStack(alignment: .leading ,spacing: 10){
            Text(title)
                .font(.pretend(type: .semiBold, size: 20))
            Text(description)
                .font(.pretend(type: .regular, size: 12))
        }
    }
    private func MenuItemOrderButtonView(title: String, description: String? ,symbol: String) -> some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .font(.pretend(type: .bold, size: 20))
                .foregroundStyle(Color.black)
            if let description {
                Text(description)
                    .font(.pretend(type: .regular, size: 12))
                    .foregroundStyle(Color.loginTextBackground)
            }
            Spacer()
            HStack{
                Spacer()
                Image(systemName:symbol)
            }
        }
        .foregroundStyle(Color.black)
        .padding(.horizontal,12)
        .padding(.vertical,15)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(Color(red: 0.79, green: 0.77, blue: 0.77), lineWidth: 1)
        )
    }
}

#Preview {
    OrderItemView()
}

