//
//  MovieBookingView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/6/25.
//

import SwiftUI
import Combine

struct MovieBookingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var bookingViewModel = MovieViewModel()
    @State private var selectedName : String? = ""
    @State private var showMovieSearch: Bool = false
//        .init()
        private let columns = [
            GridItem(.flexible(), spacing: 24)
        ]
    
    var body: some View {
        
        VStack{
            HStack{//헤더
                //            Button(action: {
                //                if !path.isEmpty {
                //                        path.removeLast()
                //                    } else {
                //                        dismiss()
                //                    }
                //            })
                //            {
                //                Image(systemName: "arrow.left")
                //                    .resizable()
                //                    .frame(width: 16, height: 16)
                //                    .foregroundStyle(Color("black"))
                //            }
                
                Spacer()
                Text("영화별 예매")
                    .font(.bold22)
                    .foregroundStyle(Color("white"))
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 41)
            .background(Color("purple03"))
            
            VStack{//영화 선택 섹션
                HStack{
                    ZStack{
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 26, height: 24)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        Text("15")
                            .foregroundStyle(Color("white"))
                            .font(.bold18)
                    }
                    .padding(.trailing, 37)
                    if(selectedName==nil){
                        Text("")
                    }
                    else {
                        Text("\(selectedName!)")
                            .font(.bold18)
                            .foregroundStyle(Color("black"))
                    }
                    
                    Spacer()
                    Button (action: {
                        showMovieSearch = true
                        
                        
                    }){
                        Text("전체 영화")
                            .font(.semiBold14)
                            .foregroundStyle(Color("black"))
                    }
                    .frame(maxWidth: 69, maxHeight: 30)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("gray03"), lineWidth: 1))
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: columns, spacing: 8) {
                        ForEach(MovieModel.allCases, id: \.self) { movie in
                            makeMovieCard(movie, isSelected: movie == bookingViewModel.selectedMovieModel)
                                .onTapGesture {
                                    bookingViewModel.selectedMovieModel = movie
                                    selectedName = movie.returnMovieName()
                                }
                        }
                    }
                }
                HStack(spacing:8){
                    ForEach(["강남","홍대","신촌"], id: \.self) { theater in
                        let isSelected = bookingViewModel.selectedTheaterName == theater
                        Button(action: {
                            bookingViewModel.selectedTheaterName = theater
                            bookingViewModel.isDaySelectable = bookingViewModel.selectedMovieModel != nil
                        }){
                            Text(theater)
                                .font(.semiBold16)
                                .foregroundStyle(isSelected ? Color("white") : Color("gray05"))
                        }
                        .frame(maxWidth: 55, maxHeight:35)
                        .background(isSelected ? Color("purple03") : Color("gray01"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .disabled(!bookingViewModel.isTheaterSelectable)
                    }
                    Spacer()
                }
                HStack{
                    WeekCalendarView(viewModel: CalendarViewModel(), bookingViewModel: bookingViewModel)
                }
            }.padding(.horizontal, 10)
         
            VStack{
                HStack {
                    ForEach(["전체","특별관"], id: \.self) { cinema in
                        let isSelected = bookingViewModel.selectedCinemaType == cinema
                        Button(action: {
                            bookingViewModel.selectedCinemaType = cinema
                        }){
                            Text(cinema)
                                .font(.semiBold16)
                                .foregroundStyle(isSelected ? Color("white") : Color("gray05"))
                        }
                        .frame(maxWidth: 55, maxHeight:35)
                        .background(isSelected ? Color("purple03") : Color("gray01"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))                        
                    }
                    Spacer()
                }
                HStack{
                    Text("\(bookingViewModel.selectedTheaterName)")
                        .font(.bold18)
                    Spacer()
                    Button (action: {
                        
                    }){
                        Text("극장안내")
                            .font(.semiBold14)
                            .foregroundStyle(Color("black"))
                    }
                    .frame(maxWidth: 69, maxHeight: 30)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("gray03"), lineWidth: 1))
                }
                if bookingViewModel.showScreeningInfo {
                    Text("선택한 극장 상영정보")
                        .font(.semiBold16)
                        .foregroundStyle(.black)
                } else if bookingViewModel.selectedTheaterName != nil {
                    Text("선택한 극장에 상영시간표가 없습니다")
                        .font(.semiBold16)
                        .foregroundStyle(.gray)
                }
            }.padding(.horizontal, 10)
                
            
            Spacer()
        }
        .sheet(isPresented: $showMovieSearch) {
            MovieSearchView(
                    onMovieSelected: { movie in
                        bookingViewModel.selectedMovieModel = movie
                        selectedName = movie.returnMovieName()
                        showMovieSearch = false
                    }
                )
        }
        
    }
}



private func makeMovieCard(_ model: MovieModel, isSelected: Bool = false) -> some View {
    let movie = model.returnMovie()
    return VStack(alignment: .leading, spacing: 8){
        if(!isSelected){
            Image(movie.image)
                .resizable()
                .frame(maxWidth: 62, maxHeight: 89)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        else{//선택된 영화
            Image(movie.image)
                .resizable()
                .frame(maxWidth: 62, maxHeight: 89)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("purple03"), lineWidth: 1)
                )
        }
    }
}


//private func makeMovieCard(_ model: CalendarViewModel, isSelected: Bool = false) -> some View {
//    let movie = model
//    return VStack(alignment: .leading, spacing: 8){
//        if(!isSelected){
//            Image(movie.image)
//                .resizable()
//                .frame(maxWidth: 62, maxHeight: 89)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//        }
//        else{//선택된 영화
//            Image(movie.image)
//                .resizable()
//                .frame(maxWidth: 62, maxHeight: 89)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color("purple03"), lineWidth: 1)
//                )
//        }
//    }
//}




#Preview {
    MovieBookingView()
    
}
