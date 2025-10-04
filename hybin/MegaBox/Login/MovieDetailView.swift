//
//  MovieDetailView.swift
//  MegaBox
//
//  Created by 전효빈 on 10/2/25.
//

import Foundation
import SwiftUI



struct MovieDetailView : View {
    let movie : MovieModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body : some View{
        VStack{
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(Color.black)
                }
                Spacer()
                Text(movie.title)
                    .font(.pretend(type: .bold, size: 20))
                    .lineLimit(1)
                Spacer()
                Spacer().frame(width: 44) // 오른쪽 빈 공간
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            VStack{
                movieImageDetailView
                movieTitleDetailView
                movieDescriptionView
            }
            VStack(alignment:.leading){
                HStack(alignment: .center){
                    //탭버튼 위치
                    Text("상세정보")
                        .frame(maxWidth: .infinity)
                    Text("관람후기")
                        .frame(maxWidth: .infinity)
                }
                Divider()
                HStack(alignment:.top){
                    movie.posterImage
                        .resizable()
                        .frame(width:100, height:120)
                        .scaledToFit()
                    VStack(spacing: 10){
                        Text("12세 이상 관람가")
                        Text("2025.10.2 개봉")
                    }
                }
                .padding(.horizontal, 20)
            }.padding(.top ,20)
            
            Spacer()
        }
        
    }
    
    private var movieImageDetailView: some View{
        Rectangle()
            .foregroundStyle(Color.clear)
            .frame(maxWidth: .infinity,minHeight: 248, maxHeight: 248)
            .background(
                Image(.exampleMovieDetailView)
                    .resizable()
                    .scaledToFit()
                    .clipped()
            )
    }
    
    private var movieTitleDetailView: some View{
        Group {
            Text(movie.title)
                .font(.pretend(type: .bold  ,size: 24))
            Text("영어" + movie.title)//영어
                .font(.pretend(type: .semiBold, size: 14))
                .foregroundStyle(Color.loginTextBackground)
        }
    }
    
    private var movieDescriptionView: some View{
        Text("최고가 되지 못한 전설 VS 최고가 되고 싶은 루키\n\n한때 주목받는 유망주였지만 끔찍한 사고로 F1에서 우승하지 못하고\n한순간에 추락한 드라이버 ‘손; 헤이스'(브래드 피트).\n그의 오랜 동료인 ‘루벤 세르반테스'(하비에르 바르뎀)에게\n레이싱 복귀를 제안받으며 최하위 팀인 APGXP에 합류한다.")
            .font(.pretend(type: .semiBold, size: 18))
            .foregroundStyle(Color.loginTextBackground)
            .padding(.horizontal, 10)
    }
}

//#Preview {
//    MovieDetailView()
//}
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = MovieModel(
            title: "F1: Movie Title",
            posterImage: .init(.모노노케히메),
            audience : 10, // Assets에 넣은 이미지 이름
            bookranking: 10

        )
        
        MovieDetailView(movie: sampleMovie)
    }
}
