//
//  HomeView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/30/25.
//

import Foundation
import SwiftUI

struct HomeView: View{
    @State private var viewModel : HomeViewModel = .init()
    
    var body: some View {
        ScrollView(.vertical) {
            megaboxLogo
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical , 10)
            headerSegment
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            headerSegement2
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            moviePosterView(movieVM: viewModel)
                .padding(.leading, 15)
            movieFeed
            movieArticle
        }
    }
    
    private var megaboxLogo : some View {
        Image(.megaBoxLogo)
    }
    
    private var headerSegment: some View {
        VStack{
            HStack {
                Text("홈")
                Spacer()
                Text("이벤트")
                Spacer()
                Text("스토어")
                Spacer()
                Text("선호극장")
                
            }.frame(width: 320 , alignment: .center)
        }
    }
    
    
    private var headerSegement2: some View {
        VStack{
            HStack {
                Text("개봉")
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                Spacer()
                Text("야밍")
            }.frame(width:84)
        }
    }
    
    private func moviePosterView(movieVM: HomeViewModel) -> some View {
        ScrollView(.horizontal) {
            HStack{
                ForEach(movieVM.movieModel) { movie in
                    
                    movieCardView(movie: movie)
                }
            }
        }
    }
    
    private func movieCardView(movie: MovieModel) -> some View{

        VStack{
            movie.posterImage
            Text(movie.title)
                .font(.pretend(type:.bold, size:32))
            Text("누적 관객수 \(movie.audience)만")
                .font(.pretend(type:.medium, size: 18))
//            Text("\(movie.bookranking)")
        }
        
    }
    

    
    private var movieFeed: some View {
        VStack(spacing:4){
            Text("MovieFeed")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            Rectangle()
                .frame(width:400, height:200)
        }
    }
    
    private var movieArticle: some View {
        VStack(alignment: .leading) {
            
            
            //각 열
            HStack{
                Text("hi")
            }
            
        }
    }
}

#Preview {
    HomeView()
}
