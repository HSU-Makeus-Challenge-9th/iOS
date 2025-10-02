//
//  Fonts.swift
//  MegaBox
//
//  Created by 전효빈 on 9/20/25.
//
// Pretendard Font

import Foundation
import SwiftUI

public extension Font {
    enum Pretend{
        case extraBold
        case bold
        case medium
        case light
        case extraLight
        case regular
        case semiBold
        case thin
        
        var value:String {
            switch self {
            case .extraBold: return "Pretendard-ExtraBold"
            case .bold: return "Pretendard-Bold"
            case .medium: return "Pretendard-Medium"
            case .light: return "Pretendard-Light"
            case .extraLight: return "Pretendard-ExtraLight"
            case .regular: return "Pretendard-Regular"
            case .semiBold: return "Pretendard-SemiBold"
            case .thin: return "Pretendard-Thin"
            }
        }
    }
    
    static func pretend(type:Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
//    static var PretendardBold30: Font {
//        return .pretend(type: .bold, size: 30)
//    }
//    
//    static var PretendardLight26: Font {
//        return .pretend(type: .light, size: 26)
//    }
}
