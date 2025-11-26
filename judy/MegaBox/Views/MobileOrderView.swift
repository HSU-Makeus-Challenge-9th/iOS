import SwiftUI

struct MobileOrderView: View {
    // MARK: - Data
    
    private let theaterName = "강남"
    
    // 추천 메뉴
    private let recommendedItems: [MenuItemModel] = [
        MenuItemModel(
            name: "러브 콤보",
            description: "영화 볼 때 딱 좋은 두 잔 세트",
            price: 10_900,
            imageName: "love_combo",
            isBest: false,
            isRecommended: true,
            isSoldOut: false,
            discountRate: nil
        ),
        MenuItemModel(
            name: "더블 콤보",
            description: "팝콘(L) + 탄산 2잔",
            price: 24_900,
            imageName: "double_combo",
            isBest: false,
            isRecommended: true,
            isSoldOut: false,
            discountRate: nil
        ),
        MenuItemModel(
            name: "디즈니 픽사 포스터",
            description: "한정판 디즈니·픽사 포스터",
            price: 15_900,
            imageName: "disneyPixar_poster",
            isBest: false,
            isRecommended: true,
            isSoldOut: false,
            discountRate: nil
        )
    ]
    
    // 베스트 메뉴
    private let bestItems: [MenuItemModel] = [
        MenuItemModel(
            name: "싱글 패키지",
            description: "팝콘(M) + 탄산(M) 1잔",
            price: 10_900,
            imageName: "single_package",
            isBest: true,
            isRecommended: false,
            isSoldOut: false,
            discountRate: nil
        ),
        MenuItemModel(
            name: "더블 콤보",
            description: "팝콘(L) + 탄산 2잔",
            price: 24_900,
            imageName: "double_combo",
            isBest: true,
            isRecommended: false,
            isSoldOut: false,
            discountRate: nil
        ),
        MenuItemModel(
            name: "러브 콤보 패키지",
            description: "팝콘 + 음료 + 굿즈 패키지",
            price: 32_000,
            imageName: "loveCombo_package",
            isBest: true,
            isRecommended: false,
            isSoldOut: false,
            discountRate: nil
        )
    ]
    
    // 디테일 페이지에서만 추가로 보이는 메뉴들
    private let extraDetailItems: [MenuItemModel] = [
        MenuItemModel(
            name: "패밀리 콤보 패키지",
            description: "온 가족이 함께 즐기는 패키지",
            price: 47_000,
            imageName: "familyCombo_package",
            isBest: true,
            isRecommended: false,
            isSoldOut: false,
            discountRate: nil
        ),
        MenuItemModel(
            name: "메가박스 오리지널 티켓북 시즌4 돌비시네마 에디션 단품",
            description: "돌비시네마 전용 한정판 티켓북",
            price: 10_900,
            imageName: "dolbyCinema",
            isBest: false,
            isRecommended: true,
            isSoldOut: false,
            discountRate: nil
        ),
        MenuItemModel(
            name: "인사이드아웃2 감정",
            description: "인사이드아웃2 굿즈 패키지",
            price: 29_900,
            imageName: "insideout_poster",
            isBest: false,
            isRecommended: true,
            isSoldOut: false,
            discountRate: 10
        )
    ]
    
    /// 상세 페이지에 넘길 전체 메뉴
    private var allMenuItems: [MenuItemModel] {
        recommendedItems + bestItems + extraDetailItems
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                
                // MARK: - 상단 헤더
                HStack {
                    Image("homeLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                    
                    Spacer()
                    
                    Image(systemName: "bell")
                    Image(systemName: "magnifyingglass")
                }
                .padding(.top, 4)
                .padding(.horizontal, 16)
                
                // MARK: - 극장 변경 바
                TheaterChangeBar(theaterName: theaterName) {
                    print("극장 변경 tapped (모바일 오더)")
                }
                .primaryTheaterStyle()
                
                // MARK: - 바로 주문 / 스토어 교환권 / 선물하기
                quickOrderSection
                
                // MARK: - 어디서든 팝콘 만나기
                deliverySection
                
                // MARK: - 추천 메뉴
                menuHorizontalSection(
                    title: "추천 메뉴",
                    subtitle: "영화 볼 때 뭐 먹지 고민될 땐 추천 메뉴!",
                    items: recommendedItems
                )
                
                // MARK: - 베스트 메뉴
                menuHorizontalSection(
                    title: "베스트 메뉴",
                    subtitle: "영화 볼 때 뭐 먹지 고민될 땐 베스트 메뉴!",
                    items: bestItems
                )
            }
            .padding(.bottom, 24)
        }
        .background(Color.white)
    }
    
    // MARK: - Sections
    
    /// 바로 주문 / 스토어 교환권 / 선물하기
    private var quickOrderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                
                NavigationLink {
                    MobileOrderDetailView(
                        theaterName: theaterName,
                        menuItems: allMenuItems
                    )
                } label: {
                    QuickActionLargeCard(
                        title: "바로 주문",
                        subtitle: "이제 줄서지 말고\n모바일로 주문하고 픽업!",
                        imageName: "order_popcorn"
                    )
                }
                .buttonStyle(.plain)
                
                VStack(spacing: 12) {
                    QuickActionSmallCard(
                        title: "스토어 교환권",
                        subtitle: "선물 받은 교환권 사용",
                        imageName: "store_exchange"
                    )
                    
                    QuickActionSmallCard(
                        title: "선물하기",
                        subtitle: "친구에게 팝콘 선물",
                        imageName: "present"
                    )
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    /// 어디서든 팝콘 만나기
    private var deliverySection: some View {
        HStack {
            QuickActionDeliveryCard(
                title: "어디서든 팝콘 만나기",
                subtitle: "팝콘 콜라 스낵 모든 메뉴 배달 가능!",
                imageName: "delivery"
            )
        }
        .padding(.horizontal, 16)
    }
    
    /// 공통 가로 스크롤 섹션
    private func menuHorizontalSection(
        title: String,
        subtitle: String?,
        items: [MenuItemModel]
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(
                    Font.custom("Pretendard", size: 18)
                        .weight(.semibold)
                )
                .foregroundColor(.black)
                .padding(.horizontal, 16)
            
            if let subtitle {
                Text(subtitle)
                    .font(Font.custom("Pretendard", size: 12))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        MenuThumbnailTile(item: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
            }
            .padding(.bottom, 4)
        }
    }
}

// MARK: - QuickActionCard (Large / Small / Delivery)

/// 바로 주문
private struct QuickActionLargeCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(
                        Font.custom("Pretendard", size: 16)
                            .weight(.semibold)
                    )
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(Font.custom("Pretendard", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer(minLength: 0)
            
            HStack {
                Spacer()
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

/// 오른쪽 카드들
private struct QuickActionSmallCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(
                        Font.custom("Pretendard", size: 15)
                            .weight(.semibold)
                    )
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(Font.custom("Pretendard", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer(minLength: 0)
            
            HStack {
                Spacer()
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 26)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

/// 어디서든 팝콘 만나기 카드
private struct QuickActionDeliveryCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(
                        Font.custom("Pretendard", size: 15)
                            .weight(.semibold)
                    )
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(Font.custom("Pretendard", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 28)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

// MARK: - 추천/베스트 메뉴용 타일

private struct MenuThumbnailTile: View {
    let item: MenuItemModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemGray6))       // 살짝 회색 배경
                if UIImage(named: item.imageName) != nil {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding(8)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray5))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(width: 180, height: 160)
            
            Text(item.name)
                .font(
                    Font.custom("Pretendard", size: 13)
                        .weight(.regular)
                )
                .foregroundColor(.black)
            
            Text(item.price.formattedPrice)
                .font(
                    Font.custom("Pretendard", size: 13)
                        .weight(.semibold)
                )
                .foregroundColor(.black)
        }
        .frame(width: 180, alignment: .leading)
    }
}
