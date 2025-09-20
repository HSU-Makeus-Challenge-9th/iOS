//
//  SplashView.swift
//  Week1_Practice
//
//  Created by qwnm7 on 9/20/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack(alignment: .center) { // ZStack 가운데로 정렬
            // 하얀색으로 배경 색상 지정(다크모드 시 배경 색 유지되도록)
            Color.white
                .ignoresSafeArea()

            Image("megaboxLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 249, height:84)
        }
    }
}

#Preview { SplashView() }

