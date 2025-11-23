import SwiftUI

struct MobileOrderView: View {
    // 샘플 데이터
    private let quickMenuItems = MenuItemModel.sampleItems
    private let theaterName = "강남"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - 극장 변경 바
                    TheaterChangeBar(theaterName: theaterName) {
                        print("극장 변경 tapped (모바일 오더)")
                    }
                    .primaryTheaterStyle()

                    // MARK: - 바로 주문 / 스토어 교환권 / 선물하기 카드
                    quickOrderSection

                    // MARK: - 추천 메뉴 (가로 스크롤)
                    menuHorizontalSection(title: "추천 메뉴", items: quickMenuItems)

                    // MARK: - 베스트 메뉴 (가로 스크롤)
                    menuHorizontalSection(title: "베스트 메뉴", items: quickMenuItems.shuffled())
                }
                .padding(.vertical, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("모바일 오더")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Sections

    private var quickOrderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // 바로 주문 카드 (네비게이션)
                NavigationLink {
                    MobileOrderDetailView(
                        theaterName: theaterName,
                        menuItems: quickMenuItems
                    )
                } label: {
                    QuickActionCard(
                        title: "바로 주문",
                        subtitle: "메가박스 인기 스낵",
                        systemImage: "bag.fill"
                    )
                }

                // 스토어 교환권
                QuickActionCard(
                    title: "스토어 교환권",
                    subtitle: "선물 받은 교환권 사용",
                    systemImage: "ticket.fill"
                )

                // 선물하기
                QuickActionCard(
                    title: "선물하기",
                    subtitle: "친구에게 팝콘 선물",
                    systemImage: "gift.fill"
                )
            }
        }
        .padding(.horizontal, 16)
    }

    private func menuHorizontalSection(title: String,
                                       items: [MenuItemModel]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        MenuItemCardView(item: item)
                            .frame(width: 220)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - QuickActionCard

private struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)

            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 2, y: 1)
    }
}
