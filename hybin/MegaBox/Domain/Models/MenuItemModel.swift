//
//  MenuItModel.swift
//  MegaBox
//
//  Created by 전효빈 on 11/23/25.
//

import Foundation
import SwiftUI

struct MenuItemModel:Identifiable {
    let id = UUID()
    var menuImageName: String
    var menuItem: String
    var menuTitle: String
    var menuPrice: Int
    var itemIsBest : Bool
    var itemIsRecommend : Bool
    var itemIsSoldOut : Bool
}
