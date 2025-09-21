//
//  SplashView.swift
//  megaBox
//
//  Created by 은재 on 9/21/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack(alignment: .center) {
            
            Color.white.ignoresSafeArea()
            Image("meBoxLogo")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 249)
        }
    }
}

#Preview {
    SplashView()
}
