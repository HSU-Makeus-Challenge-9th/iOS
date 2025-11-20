//
//  MovieItemDTO.swift
//  megaBox
//
//  Created by 은재 on 11/17/25.
//

extension MovieItemDTO {
    func toUIMovie() -> Movie {
        Movie(
            title: title,
            audience: "",      // TMDB에 관객 수 데이터 없음
            posterName: posterPath, // TMDB 이미지는 URL로 이어 붙여서 사용
            badge: nil
        )
    }
}
