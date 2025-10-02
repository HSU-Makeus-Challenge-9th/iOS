//
//  MovieModel.swift
//  MegaBox
//
//  Created by 전효빈 on 10/2/25.
//

import Foundation
import SwiftUI


struct MovieModel: Identifiable {
    let id = UUID()
    
    let title : String
    
    let posterImage : Image
    
    let audience : Int
    
    let bookranking : Int
    
}
