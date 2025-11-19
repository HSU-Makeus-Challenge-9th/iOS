//
//  OrderButtonCard.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/20/25.
//

import SwiftUI

struct OrderButtonCard: View {
    var buttonText: String = "바로 주문"
    var buttonWidth: Int = 232
    var buttonHeight: Int = 278
    var buttonDescription: String = ""
    
    var body: some View {
            VStack(alignment: .leading) {
                Text(buttonText)
                    .font(.bold22)
                    .foregroundColor(Color("black"))
                    .padding(.leading,12)
                    .padding(.top, 15)
                Text(buttonDescription)
                    .font(.regular12)
                    .foregroundColor(Color("gray03"))
                    .multilineTextAlignment(.leading)
                    .padding(.leading,12)
                    .padding(.top, 5)
                Spacer()
                HStack {
                    Spacer()
                    Image("popcorn1")
                        .padding(.trailing,10)
                        .padding(.bottom, 10)
                }
            }
        .frame(width: CGFloat(buttonWidth), height: CGFloat(buttonHeight))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("gray03"), lineWidth: 1)
        )
    }
}

#Preview {
    OrderButtonCard()
}
