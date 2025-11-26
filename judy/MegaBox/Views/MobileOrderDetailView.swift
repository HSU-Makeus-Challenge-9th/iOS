import SwiftUI

struct MobileOrderDetailView: View {
    let theaterName: String
    let menuItems: [MenuItemModel]
    
    // 2열 그리드 레이아웃
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                // MARK: - 극장 선택 바 (상세 전용 스타일)
                TheaterChangeBar_Detail(
                    theaterName: theaterName
                ) {
                    print("극장 변경 tapped (상세)")
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 12)
                
                // MARK: - 메뉴 2열 그리드
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(menuItems) { item in
                        DetailMenuTile(item: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .background(Color.white)
        .navigationTitle("바로주문")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//// MARK: - 극장 변경 바

struct TheaterChangeBar_Detail: View {
    let theaterName: String
    let onTapChange: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Image("pin_black")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            
            Text(theaterName)
                .font(
                    Font.custom("Pretendard", size: 14)
                        .weight(.semibold)
                )
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: onTapChange) {
                Text("극장 변경")
                    .font(
                        Font.custom("Pretendard", size: 13)
                            .weight(.semibold)
                    )
                    .foregroundColor(Color("purple03"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        Capsule()
                            .stroke(Color("grey07"), lineWidth: 1)
                    )
            }
        }
    }
}

//// MARK: - 상세 메뉴 타일

struct DetailMenuTile: View {
    let item: MenuItemModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(height: 180)
                    .overlay(
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // BEST / 추천 뱃지
                if item.isBest {
                    badge(text: "BEST", color: Color(red: 1, green: 0.25, blue: 0.25))
                } else if item.isRecommended {
                    badge(text: "추천", color: Color.blue)
                }
                
                // 품절일 경우 오버레이
                if item.isSoldOut {
                    soldoutOverlay
                }
            }
            
            // 메뉴명
            Text(item.name)
                .font(Font.custom("Pretendard", size: 14))
                .foregroundColor(.black)
                .lineLimit(1)
            
            // 가격
            Text(item.price.formattedPrice)
                .font(Font.custom("Pretendard", size: 14).weight(.semibold))
                .foregroundColor(.black)
        }
    }
    
    // MARK: - 추천 / BEST 뱃지
    private func badge(text: String, color: Color) -> some View {
        Text(text)
            .font(Font.custom("Pretendard", size: 10).weight(.semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(6)
    }
    
    // MARK: - 품절 오버레이
    private var soldoutOverlay: some View {
        ZStack {
            Color.black.opacity(0.45)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            Text("품절")
                .font(Font.custom("Pretendard", size: 16).weight(.bold))
                .foregroundColor(.white)
        }
        .frame(height: 180)
    }
}
