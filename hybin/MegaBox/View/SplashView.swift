//
//  SplashView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/20/25.
//

import Foundation
import SwiftUI


struct SplashView : View {
    
    @State private var isActive: Bool = false
    
    @Environment(UserSessionManager.self) var userSessionManager
    
    var body: some View {
        ZStack(alignment: .center){
            Image(.meboxLogo)
        }
        .foregroundStyle(Color.white)
        .onAppear {
            Task {
                _ = await userSessionManager.checkAutoLogin()
                
                self.isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            MainTabView()
                .environment(userSessionManager)
        }
    }
}

#Preview {
    SplashView()
}
