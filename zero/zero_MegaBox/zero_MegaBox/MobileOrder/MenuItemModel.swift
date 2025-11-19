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
    init(id: UUID, name: String, image: String, price: String) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
    }
}

enum MenuItemModel: CaseIterable {
    case love
    case single
    case double
    case poster
    
    func returnMenu() -> Menu {
        switch self {
        case .love:
            return Menu(id: .init(), name: "러브 콤보", image: "menu_love", price: "10,900원")
        case .single:
            return Menu(id: .init(), name: "싱글 패키지", image: "menu_single", price: "7,900원")
        case .double:
            return Menu(id: .init(), name: "더블 콤보", image: "menu_double", price: "24,900원")
        case .poster:
            return Menu(id: .init(), name: "디즈니 픽사 포스터", image: "menu_poster", price: "15,900원")
        }
    }
}
