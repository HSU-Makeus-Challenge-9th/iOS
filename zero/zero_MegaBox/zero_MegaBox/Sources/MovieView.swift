//
//  MovieView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/2/25.
//

import SwiftUI
struct MovieView: View {
    @Binding var path: NavigationPath
    var viewModel: MovieViewModel = .init()
        private let columns = [
            GridItem(.flexible(), spacing: 24)
        ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: columns, spacing: 24) {
                ForEach(MovieModel.allCases, id: \.self) { movie in
                    makeMovieCard(movie)
                        .onTapGesture {
                            viewModel.selectedMovieModel = movie
                            path.append(Route.movieDetail(movie))
                        }
                }
            }
        }
    }
    
    
    private func makeMovieCard(_ model: MovieModel) -> some View {
        let movie = model.returnMovie()
        return VStack(alignment: .leading, spacing: 6){
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
            .frame(maxWidth: 148, maxHeight: 36)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("purple03"), lineWidth: 1)
            )
            
            Text(movie.title)
                .font(.bold22)
                .foregroundStyle(Color("black"))
            Text(movie.count)
                .font(.medium18)
                .foregroundStyle(Color("black"))
        }
        .frame(maxWidth: 148, minHeight: 318)
        
    }
    
}
//#Preview {
//    MovieView()
//}
