import Foundation

struct MenuItemModel: Identifiable {
    let id = UUID()
    let title: String
    let price: String
    let imageName: String

    let originalPrice: String?
    let isBest: Bool
    let isRecommended: Bool
    let isSoldOut: Bool

    init(
        title: String,
        price: String,
        imageName: String,
        originalPrice: String? = nil,
        isBest: Bool = false,
        isRecommended: Bool = false,
        isSoldOut: Bool = false
    ) {
        self.title = title
        self.price = price
        self.imageName = imageName
        self.originalPrice = originalPrice
        self.isBest = isBest
        self.isRecommended = isRecommended
        self.isSoldOut = isSoldOut
    }
}

