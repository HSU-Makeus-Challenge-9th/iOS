//
//  OrderItemDetailView.swift
//  MegaBox
//
//  Created by 전효빈 on 11/23/25.
//

import Foundation
import SwiftUI

struct OrderItemDetailView : View{
    @State private var viewModel: OrderItemViewModel = .init()
    var body : some View {
        ZStack{
            
            ScrollView {
                VStack(spacing: 0) {
                    TheaterChangeBarView(selectedTheaterName: "강남", action: {print("극장 변경")})
                        .newTheaterBar(newForegroundColor: .loginBackground, newBackgroundColor: .clear)
                }
                .padding(.vertical, 10)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2),spacing:10) {
                    ForEach(viewModel.menuItem) { item in
                        MenuItemView(item:item)
                            .bestBadge(isBest: item.itemIsBest)
                            .recommendBadge(isRecommend: item.itemIsRecommend)
                        
                    }
                }
                
            }
        }
    }
}
