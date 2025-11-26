import SwiftUI

struct MenuItemCardView: View {
    let item: MenuItemModel

    var body: some View {
        HStack(spacing: 12) {
            // 썸네일
            ZStack {
                if UIImage(named: item.imageName) != nil {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    // 이미지 없을 때 플레이스홀더
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.title2)
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            // 텍스트 영역
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer(minLength: 0)

                Text(item.price.formattedPrice)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }

            Spacer()
        }
        .padding(12)
        // 상태 표현은 ViewModifier 조합으로
        .cardShadow()
        .bestBadge(item.isBest)
        .recommendedBadge(item.isRecommended)
        .discountBadge(item.discountRate)
        .soldOutOverlay(item.isSoldOut)
    }
}
