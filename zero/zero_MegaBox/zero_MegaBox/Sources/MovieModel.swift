//
//  MovieModel.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/2/25.
//

import Foundation
import SwiftUI

struct Movie{
    let title: String
    let image: String
    let count: String
}

enum MovieModel: CaseIterable {
    case yadang
    case boss
    case mono
    case infinite
    
    func returnMovie() -> Movie {
        switch self {
        case .yadang:
            return Movie(title: "야당", image: "야당", count: "누적관객수 1")
        case .boss:
            return Movie(title: "보스", image: "보스", count: "누적관객수 10만")
        case .mono:
            return Movie(title: "모노노케 히메", image: "모노노케히메", count: "누적관객수 12")
        case .infinite:
            return Movie(title: "무한성", image: "무한성", count: "누적관객수 100만")
        }
    }
    
    func returnMovieName() -> String {
            return self.returnMovie().title
    }
    
}
