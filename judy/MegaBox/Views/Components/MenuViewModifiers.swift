import SwiftUI

// MARK: - TheaterChangeBar Style

struct PrimaryTheaterStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.purple.opacity(0.9))
            .foregroundColor(.white)
    }
}

struct DetailTheaterStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}

extension View {
    /// 모바일 오더 탭 상단
    func primaryTheaterStyle() -> some View {
        self
            .modifier(PrimaryTheaterStyleModifier())
    }

    /// 상세 페이지 상단
    func detailTheaterStyle() -> some View {
        self
            .modifier(DetailTheaterStyleModifier())
    }
}

// MARK: - Menu Card 상태용 Modifier

struct CardShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(radius: 4, y: 2)
    }
}

struct BestBadgeModifier: ViewModifier {
    let isBest: Bool

    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            content
            if isBest {
                Text("BEST")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(8)
            }
        }
    }
}

struct RecommendedBadgeModifier: ViewModifier {
    let isRecommended: Bool

    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            content
            if isRecommended {
                Text("추천")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(8)
            }
        }
    }
}

struct DiscountBadgeModifier: ViewModifier {
    let discountRate: Int?

    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
            if let rate = discountRate {
                Text("\(rate)%")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(8)
            }
        }
    }
}

struct SoldOutOverlayModifier: ViewModifier {
    let isSoldOut: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            if isSoldOut {
                Color.white.opacity(0.7)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                Text("품절")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
    }
}

// MARK: - View Extension

extension View {
    func cardShadow() -> some View {
        self.modifier(CardShadowModifier())
    }

    func bestBadge(_ isBest: Bool) -> some View {
        self.modifier(BestBadgeModifier(isBest: isBest))
    }

    func recommendedBadge(_ isRecommended: Bool) -> some View {
        self.modifier(RecommendedBadgeModifier(isRecommended: isRecommended))
    }

    func discountBadge(_ discountRate: Int?) -> some View {
        self.modifier(DiscountBadgeModifier(discountRate: discountRate))
    }

    func soldOutOverlay(_ isSoldOut: Bool) -> some View {
        self.modifier(SoldOutOverlayModifier(isSoldOut: isSoldOut))
    }
}
