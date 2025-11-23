import SwiftUI

struct MobileOrderDetailView: View {
    let theaterName: String
    let menuItems: [MenuItemModel]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TheaterChangeBar(theaterName: theaterName) {
                    print("극장 변경 tapped (상세)")
                }
                .detailTheaterStyle()

                LazyVStack(spacing: 12) {
                    ForEach(menuItems) { item in
                        MenuItemCardView(item: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("바로 주문")
        .navigationBarTitleDisplayMode(.inline)
    }
}
