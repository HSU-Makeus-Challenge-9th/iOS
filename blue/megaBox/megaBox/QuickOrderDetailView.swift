import SwiftUI

struct QuickOrderDetailView: View {

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private let items: [QuickOrderItem] = [
        .init(imageName: "menu7",
              title: "싱글 콤보",
              price: "10,900원",
              originalPrice: nil,
              badge: .best,
              isSoldOut: false),
        .init(imageName: "menu1",
              title: "러브 콤보",
              price: "10,900원",
              originalPrice: nil,
              badge: .best,
              isSoldOut: false),
        .init(imageName: "menu2",
              title: "더블 콤보",
              price: "24,900원",
              originalPrice: nil,
              badge: .best,
              isSoldOut: false),
        .init(imageName: "menu5",
              title: "러브 콤보 패키지",
              price: "32,000원",
              originalPrice: nil,
              badge: nil,
              isSoldOut: false),
        .init(imageName: "menu6",
              title: "패밀리 콤보 패키지",
              price: "47,000원",
              originalPrice: nil,
              badge: nil,
              isSoldOut: false),
        .init(imageName: "ticketbook",
              title: "메가박스 오리지널 티켓북 시즌4 돌비...",
              price: "10,900원",
              originalPrice: nil,
              badge: .recommend,
              isSoldOut: false),
        .init(imageName: "menu3",
              title: "디즈니 픽사 포스터",
              price: "15,900원",
              originalPrice: nil,
              badge: nil,
              isSoldOut: true),
        .init(imageName: "insideout",
              title: "인사이드아웃2 감정",
              price: "29,900원",
              originalPrice: "35,900원",
              badge: nil,
              isSoldOut: false)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {

                QuickOrderTheaterBar(
                    theaterName: "강남",
                    onChangeTap: {
                        print("극장 변경 탭")
                    }
                )

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items) { item in
                        QuickOrderMenuCard(item: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("바로주문")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("장바구니 버튼 탭")
                } label: {
                    Image("cart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                }
            }
        }
    }
}

struct QuickOrderItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let price: String
    let originalPrice: String?
    let badge: QuickOrderBadgeType?
    let isSoldOut: Bool
}

enum QuickOrderBadgeType {
    case best
    case recommend
}

struct QuickOrderTheaterBar: View {
    let theaterName: String
    let onChangeTap: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image("map")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundColor(.black)

            Text(theaterName)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)

            Spacer()

            Button(action: onChangeTap) {
                Text("극장 변경")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color("purple03"))
                    .frame(width: 65, height: 28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("purple03"), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
    }
}

struct QuickOrderMenuCard: View {
    let item: QuickOrderItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            ZStack(alignment: .topLeading) {
                ZStack {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFill()                       // 카드 꽉 채우기
                        .frame(height: 180)
                        .clipped()

                    if item.isSoldOut {
                        Image("blackblur")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipped()

                        Text("품절")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }

                if let badge = item.badge {
                    QuickOrderBadgeView(type: badge)
                        .padding(.top, 0)
                        .padding(.leading, 0)
                }
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.99))
            .clipShape(RoundedRectangle(cornerRadius: 18))

            Text(item.title)
                .font(.system(size: 14, weight: .regular))   // 상품명 조금 얇게
                .foregroundColor(.primary)
                .lineLimit(2)

            HStack(spacing: 4) {
                if let original = item.originalPrice {
                    Text(original)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .strikethrough()
                }

                Text(item.price)
                    .font(.system(size: 14, weight: .semibold))  // 가격은 강조
                    .foregroundColor(.primary)
            }
        }
    }
}


struct QuickOrderBadgeView: View {
    let type: QuickOrderBadgeType

    private var assetName: String {
        switch type {
        case .best: return "badge1"    // 붉은 BEST 뱃지
        case .recommend: return "badge2" // 파란 추천 뱃지
        }
    }

    private var labelText: String {
        switch type {
        case .best: return "BEST"
        case .recommend: return "추천"
        }
    }

    var body: some View {
        ZStack {
            Image(assetName)
                .resizable()
                .aspectRatio(contentMode: .fill)

            Text(labelText)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 51, height: 25) // 뱃지 에셋 크기에 맞게 고정
    }
}

#Preview {
    NavigationStack {
        QuickOrderDetailView()
    }
}

