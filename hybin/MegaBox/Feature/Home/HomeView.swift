//
//  HomeView.swift
//  MegaBox
//
//  Created by 전효빈 on 9/30/25.
//

import Foundation
import SwiftUI

struct HomeView: View{
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        
        if let errorMessage = viewModel.errorMessage {
                        VStack {
                            Text("데이터 로딩 실패")
                                .font(.headline)
                            Text(errorMessage) // 👈 여기에 에러 내용이 뜹니다.
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        .padding()
                    }
        else{NavigationStack{
            ScrollView(.vertical) {
                megaboxLogoView
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical , 10)
                headerSegmentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                headerSegement2View
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                moviePoster
                    .padding(.top, 20)
                    .padding(.leading, 15)
                movieFeedView
                    .padding(.top, 30)
                movieArticleView
            }
            .task {
                await viewModel.loadMovies()
            }
        }}
    }
    
    private var megaboxLogoView : some View {
        Image(.megaBoxLogo)
    }
    
    private var headerSegmentView: some View {
        VStack{
            HStack {
                Text("홈")
                    .font(.pretend(type: .semiBold, size: 24))
                Spacer()
                Text("이벤트")
                    .font(.pretend(type: .semiBold, size: 24))
                    .foregroundStyle(Color.gray)
                Spacer()
                Text("스토어")
                    .font(.pretend(type: .semiBold, size: 24))
                    .foregroundStyle(Color.gray)
                Spacer()
                Text("선호극장")
                    .font(.pretend(type: .semiBold, size: 24))
                    .foregroundStyle(Color.gray)
                
            }.frame(width: 320 , alignment: .center)
        }
    }
    
    
    private var headerSegement2View: some View {
        VStack{
            HStack(spacing: 24) {
                Button {
//                            viewModel.selectTab(.movieChart)
                    print("hi")
                        } label: {
                            Text("무비차트")
                                // 색상을 흰색으로 지정
                                .foregroundStyle(Color.white)
                                .font(.pretend(type: .medium, size: 14))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(Color.black)
                                .clipShape(Capsule())
                        }
                Button {
//                            viewModel.selectTab(.movieChart)
                    print("hi")
                        } label: {
                            Text("상영예정")
                                // 색상을 흰색으로 지정
                                .foregroundStyle(Color.white)
                                .font(.pretend(type: .medium, size: 14))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(Color.gray)
                                .clipShape(Capsule())
                        }
            }.frame(width:192)
        }
    }
    
//    private func moviePosterView(movieVM: HomeViewModel) -> some View {
//        ScrollView(.horizontal) {
//            LazyHStack(spacing:24){
//                ForEach(movieVM.movieModel) { movie in
//                    
//                    movieCardView(movie: movie)
//                }
//            }
//        }
//    }
    
    private var moviePoster : some View{
        ScrollView(.horizontal){
            LazyHStack(spacing:24){
                ForEach(viewModel.movieModel) { movie in
                    movieCardView(movie: movie)
                }
            }
        }
    }
    
    private func movieCardView(movie: MovieModel) -> some View{
        
        VStack(alignment:.leading,spacing:4){
            NavigationLink(destination: MovieDetailView(movie: movie)) {
                movie.posterImage
                    .resizable()
            }
// ---MARK: 여기 고치기
            
            NavigationLink(destination: MovieReserveView(selectedMovie: movie)) {
                Text("바로 예매")
                    .font(.pretend(type: .medium, size: 16))
                    .foregroundStyle(Color.loginBackgroundColor)
                    .padding(.horizontal)
                    .padding(.vertical, 9)
                    .frame(maxWidth: .infinity , alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke((Color.loginBackgroundColor), lineWidth: 1)
                    )
            }
            
            Text(movie.title)
                .font(.pretend(type:.bold, size: 22))
                .frame(alignment:.leading)
            Text("누적 관객수 \(movie.audience)만")
                .font(.pretend(type:.medium, size: 18))
            //            Text("\(movie.bookranking)")
        }
        
    }
    
    
    
    private var movieFeedView: some View {
        VStack(spacing:4){
            HStack{
                Text("알고보면 더 재밌는 무비피드")
                    .font(.pretend(type: .bold, size: 24))
                Spacer()
                
                Button(action: {
                    print("more")
                }, label: {
                    Image(systemName:"arrow.right")
                        .foregroundStyle(Color.black)
                })
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(0)
            
            Image(.exampleMovieFeed)
                .resizable()
                .scaledToFit()
        }.padding(.horizontal, 15)
    }
    
    private var movieArticleView: some View {
        VStack(alignment: .leading, spacing: 39) {
            
            
            //각 열 //ForEach 일단 하드코딩
            HStack(alignment:.top){
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .frame(width: 100, height: 100)
                    .background(
                        Image(.exampleMovieArticle1)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                        )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment:.leading,spacing: 25){
                    Text("9월, 메가박스의 영화들(1) - 명작들의 재개봉’")
                        .font(.pretend(type: .semiBold, size: 16))
                        .foregroundStyle(Color.black)
                    
                    Text("<모노노케 히메>,<퍼펙트 블루>")
                        .font(.pretend(type: .semiBold, size: 11))
                        .foregroundStyle(Color.loginTextBackgroundColor)
                }
                .frame(maxWidth: .infinity ,alignment: .leading)
            }
            
            HStack(alignment:.top){
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .frame(width: 100, height: 100)
                    .background(
                        Image(.exampleMovieArticle2)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                        )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment:.leading,spacing:25){
                    Text("메가박스 오리지널 티켓 Re.37 <얼굴>")
                        .font(.pretend(type: .semiBold, size: 16))
                        .foregroundStyle(Color.black)
                    

                    
                    Text("영화 속 양극적인 감정의 대비")
                        .font(.pretend(type: .semiBold, size: 11))
                        .foregroundStyle(Color.loginTextBackgroundColor)
                }
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.top, 30)
    }
}

#Preview {
    HomeView()
}
