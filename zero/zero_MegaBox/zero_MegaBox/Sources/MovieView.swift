//
//  MovieView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/2/25.
//

import SwiftUI
struct MovieView: View {
    
    var viewModel: MovieViewModel = .init()
    
    // 3열 그리드
        private let columns = [
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 20)
        ]
    
    var body: some View {
//        movieCardGroup
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: columns, spacing: 20) {
                ForEach(MovieModel.allCases, id: \.self) { movie in
                    makeMovieCard(movie)
                        .onTapGesture {
                            viewModel.selectedMovieModel = movie
                        }
                }
            }
            .padding()
            
        }
    }
//    private var movieCardGroup: some View {
//        LazyHGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 40, count: 3), spacing: 20, content: {
//            Foreach(MovieModel.allCases, id: \.self, content: { movie in makeMovieCard(movie)
//                    .onTapGesture{
//                        viewModel.selectedMovieModel = movie
//                    }
//            })
//        })
//    }
    
    
    private func makeMovieCard(_ model: MovieModel) -> some View {
        let movie = model.returnMovie()
        return VStack(spacing: 6){
            Image(movie.image)
                .resizable()
                .frame(maxWidth: 148, minHeight: 212)
            Button(action: {
                
            }) {
                Text("바로 예매")
                    .frame(alignment: .center)
                    .font(.medium16)
                    .foregroundStyle(Color("purple03"))
            }
            .frame(maxWidth: 84, maxHeight: 38)
            .background(Color("purple03"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(movie.title)
                .font(.bold22)
                .foregroundStyle(Color("black"))
            Text(movie.count)
                .font(.medium18)
                .foregroundStyle(Color("black"))
        }
        .frame(maxWidth: 148, minHeight: 318)
    }
    
    
    
//    private func selectedMovieName() -> String {
//        if let name = viewModel.selectedMovieModel {
//            return name.returnMovieName()
//        } else {
//            return "아무것도 없음"
//        }
//    }

    
}
#Preview {
    MovieView()
}
