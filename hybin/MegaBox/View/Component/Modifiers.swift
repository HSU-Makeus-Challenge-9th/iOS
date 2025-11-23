//
//  Modifiers.swift
//  MegaBox
//
//  Created by 전효빈 on 11/23/25.
//

import Foundation
import SwiftUI

// --MARK: 극장 변경 바 스타일 수정자
struct TheaterBarStyleModifier:ViewModifier{
    let newforegroundColor:Color
    let newBackgroundColor: Color
    
    func body (content: Content) -> some View{
        content
            .foregroundStyle(newforegroundColor)
            .background(newBackgroundColor)
    }
}

// - MARK: 뱃지(추천)/ 오버레이 수정자

struct BestBadgeModifier: ViewModifier {
    let isBest : Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topLeading) {
                if isBest{
                    Text("Best")
                        .font(.pretend(type: .semiBold, size: 12))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal , 8)
                        .padding(.vertical , 4)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
            }
    }
}

struct RecommendBadgeModifier: ViewModifier {
    let isRecommend : Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topLeading) {
                if isRecommend {
                    Text("Recommend")
                        .font(.pretend(type: .semiBold, size: 12))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal , 8)
                        .padding(.vertical , 4)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
    }
}

struct SoldOutOverlayModifier: ViewModifier {
    let isSoldOut : Bool
    
    func body(content: Content) -> some View{
        content
            .overlay {
                if isSoldOut {
                    Color.black.opacity(0.6)
                    Text("품절")
                        .font(.pretend(type: .semiBold, size: 12))
                        .foregroundStyle(Color.white)
                }
            }
    }
}


extension View {
    
    func newTheaterBar(newForegroundColor: Color, newBackgroundColor: Color) -> some View {
        self.modifier(TheaterBarStyleModifier(newforegroundColor: newForegroundColor, newBackgroundColor: newBackgroundColor))
    }
    
    func bestBadge(isBest: Bool) -> some View {
        self.modifier(BestBadgeModifier(isBest: isBest))
    }
    
    func recommendBadge(isRecommend: Bool) -> some View {
        self.modifier(RecommendBadgeModifier(isRecommend: isRecommend))
    }
    
    func soldOutOverlay(isSoldOut: Bool) -> some View {
        self.modifier(SoldOutOverlayModifier(isSoldOut: isSoldOut))
    }
}
