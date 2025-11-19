//
//  D.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/20/25.
//
import SwiftUI

struct MenuDetailView: View {
    @Environment(\.dismiss) var dismiss
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    var body: some View {
        NavigationStack {
            VStack {
                TheaterBar(
                    location: "홍대",
                    backgroundColor: Color.clear,
                    foregroundColor: Color.black,
                    textColor: Color("purple03")
                )
                
                Spacer()
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(MenuItemModel.allCases.map { $0.returnMenu() }) { menu in
                            MenuCard(menu: menu, isBest: menu.isBest, isRecommend: menu.isRecommend, soldOut: menu.soldOut)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("메뉴 상세")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                    }) {
                        Image("shopping-cart")
                            .foregroundColor(.black)
                    }
                }
            }
            
            
        }
    }
}

#Preview {
    MenuDetailView()
}
