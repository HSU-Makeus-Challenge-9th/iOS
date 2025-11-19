//
//  MenuItemModel.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 11/19/25.
//

import Foundation
import SwiftUI

struct Menu: Identifiable, Hashable, Equatable {
    var id: UUID
    var name: String
    var image: String
    var price: String
    var isBest: Bool
    var isRecommend: Bool
    var soldOut: Bool
    
    init(id: UUID, name: String, image: String, price: String, isBest: Bool, isRecommend: Bool, soldOut: Bool) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.isBest = isBest
        self.isRecommend = isRecommend
        self.soldOut = soldOut
    }
}

enum MenuItemModel: CaseIterable {
    case singleCombo
    case loveCombo
    case doubleCombo
    case loveComboPackage
    case familyComboPackage
    case ticketBook
    case pixaposter
    case insideOut
    
    func returnMenu() -> Menu {
        switch self {
        case .loveCombo:
            return Menu(id: .init(), name: "러브 콤보", image: "menu_love", price: "10,900원",isBest: true ,isRecommend: false, soldOut: false)
        case .singleCombo:
            return Menu(id: .init(), name: "싱글 콤보", image: "menu_single", price: "10,900원",isBest: true ,isRecommend: false, soldOut: false)
        case .doubleCombo:
            return Menu(id: .init(), name: "더블 콤보", image: "menu_double", price: "24,900원",isBest: true ,isRecommend: false, soldOut: false)
        case .pixaposter:
            return Menu(id: .init(), name: "디즈니 픽사 포스터", image: "menu_poster", price: "15,900원",isBest: false ,isRecommend: false, soldOut: true)
        case .loveComboPackage:
            return Menu(id: .init(), name: "러브 콤보 패키지", image: "loveCombo", price: "32,000원",isBest: false ,isRecommend: false, soldOut: false)
        case .familyComboPackage:
            return Menu(id: .init(), name: "패밀리 콤보 패키지", image: "family", price: "47,000원",isBest: false ,isRecommend: false, soldOut: false)
        case .ticketBook:
            return Menu(id: .init(), name: "메가박스 오리지널 티켓북 시즌4", image: "megaTicketBook", price: "10,900원",isBest: false ,isRecommend: true, soldOut: false)
        case .insideOut:
            return Menu(id: .init(), name: "인사이드아웃2 감정", image: "insideout", price: "29,900원",isBest: false ,isRecommend: false, soldOut: false)
        }
    }
}
