import Foundation

struct MenuItemModel: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Int

    /// Assets
    let imageName: String

    // 상태값들 – ViewModifier 조합에 사용
    let isBest: Bool
    let isRecommended: Bool
    let isSoldOut: Bool
    let discountRate: Int?   // 10 -> 10% 할인 같은 느낌
}

extension MenuItemModel {
    /// 샘플 데이터 (리스트 & 디테일 둘 다에서 사용)
    static let sampleItems: [MenuItemModel] = [
        .init(
            name: "싱글 콤보",
            description: "팝콘(M) + 탄산(M) 1잔",
            price: 10900,
            imageName: "combo_single",
            isBest: true,
            isRecommended: false,
            isSoldOut: false,
            discountRate: nil
        ),
        .init(
            name: "관람 콤보",
            description: "팝콘(L) + 탄산(M) 2잔",
            price: 24900,
            imageName: "combo_double",
            isBest: true,
            isRecommended: false,
            isSoldOut: false,
            discountRate: 10
        ),
        .init(
            name: "디즈니 포스터 패키지",
            description: "한정판 굿즈 포함 패키지",
            price: 15900,
            imageName: "combo_poster",
            isBest: false,
            isRecommended: true,
            isSoldOut: false,
            discountRate: nil
        ),
        .init(
            name: "한정 스낵 패키지",
            description: "수량 한정, 조기 품절 주의",
            price: 29000,
            imageName: "combo_limited",
            isBest: false,
            isRecommended: false,
            isSoldOut: true,
            discountRate: nil
        )
    ]
}

extension Int {
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number = NSNumber(value: self)
        return (formatter.string(from: number) ?? "\(self)") + "원"
    }
}
