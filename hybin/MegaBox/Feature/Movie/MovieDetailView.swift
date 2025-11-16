//
//  MovieDetailView.swift
//  MegaBox
//
//  Created by 전효빈 on 10/2/25.
//

import Foundation
import SwiftUI
import Kingfisher

struct MovieDetailView : View {
    let movie : MovieCardModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body : some View{
        VStack(spacing: 0){
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(Color.black)
                }
                Spacer()
                Text(movie.movieTitle)
                    .font(.pretend(type: .bold, size: 20))
                    .lineLimit(1)
                Spacer()
                Spacer().frame(width: 44)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            
            ScrollView {
                VStack{
                    movieImageDetailView
                    movieTitleDetailView
                        .padding(.top, 10)
                    movieDescriptionView
                        .padding(.top, 20)
                }
                
                VStack(alignment:.leading){
                    HStack(alignment: .center){
                        Text("상세정보")
                            .frame(maxWidth: .infinity)
                        Text("관람후기")
                            .frame(maxWidth: .infinity)
                    }
                    Divider()
                    
                    
                    HStack(alignment:.top){
                        
                        KFImage(URL(string: movie.moviePoster))
                            .placeholder { ProgressView() }
                            .resizable()
                            .frame(width:100, height:120)
                            .scaledToFit()
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text(movie.ageLimit) //
                            Text("\(movie.releaseDate) 개봉")
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top ,20)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
//        .ignoresSafeArea(edges: .top)
    }
    
    
    private var movieImageDetailView: some View{
        KFImage(URL(string: movie.backdropPath))
            .placeholder {
                ZStack {
                    Color.gray.opacity(0.1)
                    ProgressView()
                }
                .frame(maxWidth: .infinity, minHeight: 248, maxHeight: 248)
            }
            .resizable()
            .scaledToFill() //
            .frame(maxWidth: .infinity, minHeight: 248, maxHeight: 248)
            .clipped()
    }
    
    
    private var movieTitleDetailView: some View{
        Group {
            Text(movie.movieTitle)
                .font(.pretend(type: .bold ,size: 24))
            Text(movie.originalTitle)
                .font(.pretend(type: .semiBold, size: 14))
                .foregroundStyle(Color.loginTextBackgroundColor)
        }
    }
    
    
    private var movieDescriptionView: some View{
        Text(movie.overview) 
            .font(.pretend(type: .semiBold, size: 18))
            .foregroundStyle(Color.loginTextBackgroundColor)
            .padding(.horizontal, 10)
    }
}
//#Preview {
//    MovieDetailView()

