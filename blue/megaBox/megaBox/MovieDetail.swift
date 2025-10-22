//
//  MovieDetail.swift
//  megaBox
//
//  Created by 은재 on 10/1/25.
//

import Foundation

struct MovieDetail: Identifiable, Hashable {
    let id = UUID()
    let title: String        // 영화 한글 제목
    let englishTitle: String // 영화 영어 제목
    let posterName: String   // 직사각형 포스터 에셋명
    let description: String  // 줄거리/설명
}
