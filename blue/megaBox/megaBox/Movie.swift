//
//  Movie.swift
//  megaBox
//
//  Created by 은재 on 10/1/25.
//

import Foundation

struct Movie: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let audience: String
    let posterName: String?
    let badge: String?
}

struct Article: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let thumbnailName: String?
}

