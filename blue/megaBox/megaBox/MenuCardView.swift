import SwiftUI

struct MenuCardView: View {
    let item: MenuItemModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 152, height: 152)
                .clipped()
                .cornerRadius(8)
                .bestBadge(item.isBest)
                .recommendBadge(item.isRecommended)
                .soldOut(item.isSoldOut)

            Text(item.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)

            HStack(spacing: 4) {
                if let original = item.originalPrice {
                    Text(original)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .strikethrough()
                }

                Text(item.price)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .discountStyle(hasDiscount: item.originalPrice != nil)
        }
        .frame(width: 152, alignment: .leading)
    }
}

// MARK: - ViewModifier들 (상태 표현용, UI 변경 없음)

struct BestBadgeModifier: ViewModifier {
    let isBest: Bool

    func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            if isBest {
                Text("BEST")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.93, green: 0.33, blue: 0.34))
                    .clipShape(RoundedRectangle(cornerRadius: 2))
            }
        }
    }
}

struct RecommendBadgeModifier: ViewModifier {
    let isRecommended: Bool

    func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            if isRecommended {
                Text("추천")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
            }
        }
    }
}

struct SoldOutModifier: ViewModifier {
    let isSoldOut: Bool

    func body(content: Content) -> some View {
        content.overlay {
            if isSoldOut {
                ZStack {
                    Color.black.opacity(0.5)
                        .cornerRadius(8)
                    Text("품절")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct DiscountStyleModifier: ViewModifier {
    let hasDiscount: Bool

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func bestBadge(_ isBest: Bool) -> some View {
        modifier(BestBadgeModifier(isBest: isBest))
    }

    func recommendBadge(_ isRecommended: Bool) -> some View {
        modifier(RecommendBadgeModifier(isRecommended: isRecommended))
    }

    func soldOut(_ isSoldOut: Bool) -> some View {
        modifier(SoldOutModifier(isSoldOut: isSoldOut))
    }

    func discountStyle(hasDiscount: Bool) -> some View {
        modifier(DiscountStyleModifier(hasDiscount: hasDiscount))
    }
}


struct TheaterBarView: View {
    let theaterName: String
    let onChangeTap: () -> Void

    var body: some View {
        HStack(spacing: 8) {

            Image("map")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundColor(.white)

            Text(theaterName)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            Button(action: onChangeTap) {
                Text("극장 변경")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 65, height: 28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10) 
        .background(Color("purple03"))
    }
}


struct QuickOrderCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("바로 주문")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)

            Text("이제 줄서지 말고\n모바일로 주문하고 픽업!")
                .font(.system(size: 13))
                .foregroundColor(.secondary)

            Spacer()

            HStack {
                Spacer()
                Image(systemName: "popcorn")
                    .font(.system(size: 30))
                    .foregroundColor(.primary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(Color.white)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

