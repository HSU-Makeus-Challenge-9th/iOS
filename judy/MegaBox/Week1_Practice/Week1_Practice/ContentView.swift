//
//  ContentView.swift
//  Week1_Practice
//
//  Created by qwnm7 on 9/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showMainView: Bool = false
    
    var body: some View {
        ZStack {
            if showMainView {
                LoginView()
            } else {
                SplashView()
                .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showMainView = true
                    }
                }
            }
        }
        .onAppear {
            // 폰트 체크 하기
            UIFont.familyNames.sorted().forEach { familyName in
                print("*** \(familyName) ***")
                UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                    print("\(fontName)")
                }
                print("---------------------")
            }
        }
    }
}

#Preview {
    ContentView()
}
