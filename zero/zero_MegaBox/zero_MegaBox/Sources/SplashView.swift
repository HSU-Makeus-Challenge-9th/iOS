//
//  SplashView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 9/18/25.
//

import SwiftUI

struct SplashView: View
{
    var body: some View
    {
        ZStack(alignment: .center){
            Color.white.ignoresSafeArea()
            Image("meboxLogo 1")
        }
    }
}
#Preview {
    SplashView()
}
