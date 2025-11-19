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
            
        }
    }
}

#Preview {
    MobileOrderView()
}
