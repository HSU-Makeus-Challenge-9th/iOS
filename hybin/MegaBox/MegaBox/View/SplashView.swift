//
//  SplashView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/20/25.
//

import Foundation
import SwiftUI


struct SplashView : View {
    var body: some View {
        ZStack(alignment: .center){
            Image(.meboxLogo)
        }.foregroundStyle(Color.white)
    }
}

#Preview {
    SplashView()
}
