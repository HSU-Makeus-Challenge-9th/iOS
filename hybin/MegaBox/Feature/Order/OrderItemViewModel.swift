//
//  OrderItemViewModel.swift
//  MegaBox
//
//  Created by 전효빈 on 11/23/25.
//

import Foundation
import SwiftUI

@Observable
class OrderItemViewModel {
    var menuItem : [MenuItemModel] = [
        MenuItemModel(menuImageName: "love_combo", menuItem: "Combo", menuTitle: "러브 콤보", menuPrice: 10900, itemIsBest: false, itemIsRecommend: true, itemIsSoldOut: false),
        MenuItemModel(menuImageName: "double_combo", menuItem: "Combo", menuTitle: "더블 콤보", menuPrice: 24900, itemIsBest: false, itemIsRecommend: true, itemIsSoldOut: false),
        
        //추천
        MenuItemModel(menuImageName: "single_combo", menuItem: "Combo", menuTitle: "싱글 콤보", menuPrice: 10900, itemIsBest: true, itemIsRecommend: false, itemIsSoldOut: false),
        
        //품절
        MenuItemModel(menuImageName: "disney_poster", menuItem: "Goods", menuTitle: "디즈니 픽사 포스터", menuPrice: 15900, itemIsBest: false, itemIsRecommend: false, itemIsSoldOut: true),
        
        //기타
        MenuItemModel(menuImageName: "insideout_figure", menuItem: "Goods", menuTitle: "인사이드아웃2 감정", menuPrice: 29900, itemIsBest: false, itemIsRecommend: false, itemIsSoldOut: false)
        
    ]
}
