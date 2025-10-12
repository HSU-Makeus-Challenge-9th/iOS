import Foundation
import SwiftUI

extension Font {

    enum Pretend {
        case black
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        case extraLight
        case thin

        var value: String {
            switch self {
            case .black:      return "Pretendard-Black"
            case .extraBold:  return "Pretendard-ExtraBold"
            case .bold:       return "Pretendard-Bold"
            case .semibold:   return "Pretendard-SemiBold"
            case .medium:     return "Pretendard-Medium"
            case .regular:    return "Pretendard-Regular"
            case .light:      return "Pretendard-Light"
            case .extraLight: return "Pretendard-ExtraLight"
            case .thin:       return "Pretendard-Thin"
            }
        }
    }

    static func pretend(type: Pretend, size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        .custom(type.value, size: size, relativeTo: relativeTo)
    }

    static func pretendBold(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        .pretend(type: .bold, size: size, relativeTo: relativeTo)
    }
    static func pretendSemiBold(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        .pretend(type: .semibold, size: size, relativeTo: relativeTo)
    }
    static func pretendRegular(_ size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        .pretend(type: .regular, size: size, relativeTo: relativeTo)
    }

    // 디자인 토큰
    static var pretendTitle: Font       { .pretend(type: .bold,     size: 28, relativeTo: .title) }
    static var pretendHeadline: Font    { .pretend(type: .semibold, size: 20, relativeTo: .headline) }
    static var pretendBody: Font        { .pretend(type: .regular,  size: 16, relativeTo: .body) }
    static var pretendCaption: Font     { .pretend(type: .medium,   size: 13, relativeTo: .caption) }
    static var pretendButton: Font      { .pretend(type: .bold,     size: 17, relativeTo: .body) }
    static var PretendardBold30: Font { .pretend(type: .bold, size: 30) }
}
