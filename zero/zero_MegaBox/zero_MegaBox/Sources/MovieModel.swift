//
//  MovieModel.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/2/25.
//

import Foundation
import SwiftUI

struct Movie: Identifiable, Hashable, Equatable{
    var id: UUID    
    let title: String
    let image: String
    let count: String
    init(id: UUID, title: String, image: String, booking: Bool = false ,count: String) {
        self.id = id
        self.title = title
        self.image = image
        self.count = count
    }
}

enum MovieModel: CaseIterable {
    case f1
    case yadang
    case boss
    case mono
    case infinite
    
    func returnMovie() -> Movie {
        switch self {
        case .f1:
            return Movie(id: .init(), title: "F1 더 무비", image: "f1", count: "누적관객수 1111")
        case .yadang:
            return Movie(id: .init(), title: "야당", image: "야당", count: "누적관객수 1")            
        case .infinite:
            return Movie(id: .init(), title: "무한성", image: "무한성", count: "누적관객수 100만")
        case .boss:
            return Movie(id: .init(), title: "보스", image: "보스", count: "누적관객수 10만")
        case .mono:
            return Movie(id: .init(), title: "모노노케 히메", image: "모노노케히메", count: "누적관객수 12")
        }
    }
    
    func returnMovieName() -> String {
            return self.returnMovie().title
    }
    
}
