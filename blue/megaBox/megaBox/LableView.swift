import SwiftUI

struct MegaboxLogoBar: View {
    var body: some View {
        HStack {
            Image("meboxLogo 1")
                .resizable()
                .scaledToFit()
                .frame(height: 24)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .padding(.bottom, 0)
    }
}

struct LableView: View {

    private let recommendedMenus: [MenuItemModel] = [
        .init(title: "러브 콤보",   price: "10,900원", imageName: "menu1"),
        .init(title: "더블 콤보",   price: "24,900원", imageName: "menu2"),
        .init(title: "디즈니 픽사 패키지", price: "15,900원", imageName: "menu3")
    ]

    private let bestMenus: [MenuItemModel] = [
        .init(title: "싱글 패키지", price: "9,900원",  imageName: "menu4"),
        .init(title: "더블 콤보",  price: "24,900원", imageName: "menu1"),
        .init(title: "러브 콤보 패키지", price: "19,900원", imageName: "menu2")
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    MegaboxLogoBar()

                    TheaterBarView(theaterName: "강남") {
                        print("극장 변경 탭")
                    }

                    VStack(spacing: 20) {
                        HStack(alignment: .top, spacing: 16) {
                            NavigationLink {
                                QuickOrderDetailView()
                            } label: {
                                QuickOrderCardView()
                            }
                            .buttonStyle(.plain)

                            VStack(spacing: 14) {
                                SmallOrderActionCard(
                                    title: "스토어 교환권",
                                    imageName: "ticket"
                                )
                                SmallOrderActionCard(
                                    title: "선물하기",
                                    imageName: "gift"
                                )
                            }
                            .frame(width: 140)
                        }

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("어디서든 팝콘 만나기")
                                    .font(.system(size: 22, weight: .semibold))
                                Text("팝콘 콜라 스낵 모든 메뉴 배달 가능!")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image("motorcycle")
                                .font(.system(size: 26))
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 16)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("추천 메뉴")
                            .font(.system(size: 22, weight: .bold))
                        Text("영화 볼 때 뭐먹지 고민될 땐 추천 메뉴!")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(recommendedMenus) { item in
                                    MenuCardView(item: item)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal, 16)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("베스트 메뉴")
                            .font(.system(size: 22, weight: .bold))
                        Text("영화 볼 때 뭐먹지 고민될 때 베스트 메뉴!")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(bestMenus) { item in
                                    MenuCardView(item: item)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 20)
                }
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct SmallOrderActionCard: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
            Spacer()
            HStack {
                Spacer()
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 100)
        .background(Color.white)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

#Preview {
    LableView()
}

