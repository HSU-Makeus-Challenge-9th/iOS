//
//  MovieSearchView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/10/25.
//

import SwiftUI
import Combine


struct MovieSearchView: View {
    @ObservedObject private var viewModel = MovieViewModel()
    var onMovieSelected: (MovieModel) -> Void
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            Text("영화 선택")
                .font(.semiBold18)
                .foregroundStyle(Color("black"))
            
           LazyVGrid(columns: columns, spacing: 16) {
               ForEach(viewModel.results.isEmpty ? MovieModel.allCases : viewModel.results, id: \.self) { movie in
                   let isSelected = viewModel.selectedMovieModel == movie
                   makeMovieCard(movie)
                       .onTapGesture {
                           onMovieSelected(movie)
                       }
               }
           }
           .padding(.horizontal, 16)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(Color("red"))
                    .padding()
            }

            List(viewModel.results, id: \.self) { movie in
                Text(movie.returnMovieName())
            }
            
            
            VStack{
                HStack {
                   Image(systemName: "magnifyingglass")
                       .foregroundStyle(Color("black"))
                   TextField("영화를 검색하세요", text: $viewModel.query)
                       .textFieldStyle(PlainTextFieldStyle())
                       .padding(10)
                    Button(action: {
                        viewModel.query = ""
                    }) {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundStyle(Color("gray01"))
                    }
               }
                
            }.padding(10)
                
            }
    }
                
        

}


private func makeMovieCard(_ model: MovieModel, isSelected: Bool = false) -> some View {
    let movie = model.returnMovie()
    return VStack(alignment: .center, spacing: 6){
        Image(movie.image)
            .resizable()
            .frame(width: 95, height: 135)
        Text(movie.title)
            .font(.semiBold14)
            .foregroundStyle(Color("black"))
    }
    .frame(width:95, height: 163)
    
}

//#Preview{
//    MovieSearchView()
//}
