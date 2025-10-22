//
//  HomeViewModel.swift
//  MegaBox
//
//  Created by 전효빈 on 9/30/25.
//

import Foundation
import SwiftUI

@Observable
class HomeViewModel {
    
    //포스터 이미지 이름으로 받아서 처리하게끔.. 수정할예정
    let movieModel: [MovieModel] = [
        .init(title: "모노노케 히메", posterImage: .init(.모노노케히메), audience: 30, bookranking: 5),
        .init(title: "어쩔수가 없다", posterImage: .init(.어쩔수가없다), audience: 25, bookranking: 5),
        .init(title: "귀멸의 칼날", posterImage: .init(.무한성), audience: 15, bookranking: 5),
        .init(title: "F1", posterImage: .init(.f1), audience: 155, bookranking: 5),
        .init(title: "보스", posterImage: .init(.보스)  , audience: 12, bookranking: 5),
    ]
    
    //MovieArticle, MovieFeed 관련해서 만들어야함.
    
}
