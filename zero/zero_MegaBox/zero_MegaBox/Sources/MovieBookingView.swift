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
    
    private let columns = [
        GridItem(.flexible(), spacing: 24)
    ]
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    var body: some View {
        
        VStack{
            HStack{
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
                        ForEach(bookingViewModel.movies, id: \.id) { movie in
                            makeMovieCard(movie, isSelected: movie.id == bookingViewModel.selectedMovieId)
                                .onTapGesture {
                                    bookingViewModel.selectedMovieId = movie.id
                                    bookingViewModel.selectedMovieModel = MovieModel.fromDomain(movie)
                                    selectedName = movie.title
                                    
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
                    VStack(alignment: .leading, spacing: 6) {
                            ForEach(bookingViewModel.filteredShowtimes, id: \.start) { showtime in
                                Text("\(showtime.start!, formatter: dateFormatter) ~ \(showtime.end!, formatter: dateFormatter)")
                                    .font(.semiBold16)
                            }
                        }
                    
                } else if bookingViewModel.selectedTheaterName != "" {
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
        .onAppear {
            Task {
                await bookingViewModel.loadMovieSchedule()
                print("View가 나타남 — 영화 데이터 로드 시도")
            }
        }
        
    }
}


//private func makeMovieCard(_ model: Movie, isSelected: Bool = false) -> some View {
//    return VStack(alignment: .leading, spacing: 8) {
//        Image(model.image)
//            .resizable()
//            .frame(maxWidth: 62, maxHeight: 89)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(isSelected ? Color("purple03") : .clear, lineWidth: 1)
//            )
//    }
//}
private func makeMovieCard(_ model: MovieDomain, isSelected: Bool = false) -> some View {
    // 서버 데이터에는 image 정보가 없으므로 title 기준으로 Asset 매핑
    let imageName: String
    switch model.title {
    case "F1 더 무비":
        imageName = "f1"
    case "귀멸의 칼날: 무한성":
        imageName = "무한성"
    case "어쩔수가없다":
        imageName = "어쩔수가없다"
    case "보스":
        imageName = "보스"
    case "모노노케 히메":
        imageName = "모노노케히메"
    case "얼굴":
        imageName = "movieface"
    default:
        imageName = "default_movie"
    }
    
    return VStack(alignment: .leading, spacing: 8) {
        Image(imageName)
            .resizable()
            .frame(maxWidth: 62, maxHeight: 89)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color("purple03") : .clear, lineWidth: 1)
            )
    }
}


#Preview {
    MovieBookingView()
    
}
