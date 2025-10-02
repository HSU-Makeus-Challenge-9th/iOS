//
//  HomeViewModel.swift
//  megaBox
//
//  Created by 은재 on 10/1/25.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var chips: [String] = ["무비차트", "상영예정"]

    @Published var movies: [Movie] = [
        Movie(title: "어쩔수가 없다",     audience: "누적관객수 20만", posterName: "amovie", badge: nil),
        Movie(title: "극장판 귀멸의 칼날", audience: "누적관객수 1",  posterName: "bmovie", badge: nil),
        Movie(title: "F1 더 무비",        audience: "누적관객수 20만", posterName: "c2movie", badge: nil)
    ]

    @Published var articles: [Article] = [
        Article(title: "9월, 메가박스의 영화들(1)-명작들의 재개봉",
                subtitle: "〈모노노케 히메〉, 〈퍼펙트 블루〉",
                thumbnailName: "emovie"),
        Article(title: "메가박스 오리지널 티켓 Re.37 〈얼굿〉",
                subtitle: "영화 속 압도적인 감정의 대비",
                thumbnailName: "fmovie")
    ]
}
