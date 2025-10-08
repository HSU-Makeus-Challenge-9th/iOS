//
//  MovieReserveView.swift
//  MegaBox
//
//  Created by 전효빈 on 10/8/25.
//

import Foundation
import SwiftUI
import Combine

struct MovieReserveView: View {
    @ObservedObject var vm: MovieReserveViewModel
    
    var body : some View {
        VStack{
            header
            Spacer()
            Text("MovieReserveView")
                .navigationBarTitle("영화 예매")
            movieList
        }
    }
    
    
    private var header: some View {
        VStack {
            Text("영화별 예매")
                .font(.title)
        }
        .padding(.top,0)
        .padding(.horizontal, 0)
        .frame(width: 440, alignment: .top)
        .background(Color.loginBackgroundColor)
    }
    
    private var movieList : some View {
        VStack{
            HStack{
                Text("상영 등급표 이미지")
                if let selected = vm.selectedMovie{
                    Text(selected.title)
                } else {Text("영화를 선택해주세요")}
                Text("전체영화 버튼")
            }
            
            ScrollView(.horizontal){
                LazyHStack{
                    ForEach(vm.movies) { movie in
                        movieCardView(movie: movie)
                    }
                }
            }
        }
    }
    
    private func movieCardView(movie: MovieModel) -> some View{
        Button(action:{
            vm.selectedMovie = movie
        } ,label: {
            movie.posterImage
                .resizable()
                .frame(width:62, height:89)
            
        })
    }
    

    
    private var movieTheaterList: some View {
        VStack{
            HStack{
                Text("Thater Name")
            }
            
            HStack{
                Text("Date")
            }
        }
    }
}

#Preview {
    MovieReserveView(vm: MovieReserveViewModel(homeVM:HomeViewModel()))
}
