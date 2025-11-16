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
    
    @State private var vm: MovieReserveViewModel
    
    init(selectedMovie: MovieModel) {
        _vm = State(initialValue: MovieReserveViewModel(selectedMovie: selectedMovie))
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingSearchSheet = false
    
    var body : some View {
        ScrollView(.vertical){
            VStack{
                header
                movieList
                    .padding(.horizontal , 16)
                    .padding(.top , 10)
                    .padding(.bottom, 32)
                movieTheaterList
                    .padding(.horizontal , 16)
                calendarSection
                    .padding(.bottom, 32)
                if vm.canReserve {
                    selectDetailView
                }
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $isShowingSearchSheet, content: {
            MovieSearchSheetView(
                vm: vm,
                onMovieSelected: { selectedMovie in
                    vm.selectedMovie = selectedMovie
                }
            )
        })
        .navigationBarBackButtonHidden(true)

        
        .task {
            await vm.loadAllMovies()
        }
        .onChange(of: vm.selectedMovie?.id) {
            Task{
                await vm.loadSchedules()
            }
        }
        .onChange(of: vm.selectedTheater) {
            Task {
                await vm.loadSchedules()
            }
        }
        .onChange(of: vm.calendarVM.selectedDate) {
            Task {
                await vm.loadSchedules()
            }
        }
    }
    
    
    
    //MARK: - 하위뷰
    
    private var header: some View {
            
                
                ZStack {
                    Text("영화별 예매")
                        .font(.pretend(type: .bold, size: 22))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top,16)
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundStyle(Color.white)
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                    }
                }
                .padding(.top, 50)
                .padding(.bottom, 10)
                
            
            .frame(maxWidth: .infinity)
            .background(Color.loginBackgroundColor)
        }
    
    private var movieList : some View {
        VStack(alignment: .leading,spacing: 20){
            HStack {
                ZStack{
                    Rectangle()
                        .foregroundStyle(Color.clear)
                        .frame(width:26, height:24)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    
                    Text("15")
                        .font(.pretend(type: .bold, size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                        .frame(width: 23, alignment: .top)
                }.padding(.trailing, 34)
                
                if let selected = vm.selectedMovie{
                    Text(selected.title)
                        .font(.pretend(type: .bold, size: 18))
                } else {
                    Text("영화를 선택해주세요")
                        .font(.pretend(type: .bold, size: 18))
                }
                
                Spacer()
                
                Button {
                    isShowingSearchSheet = true // 시트 표시 상태 변경
                } label: {
                    Text("전체영화")
                        .font(.pretend(type: .semiBold, size: 14))
                        .padding(0)
                        .frame(width: 69, height: 30 , alignment:.center)
                        .foregroundStyle(Color.black)
                        .background(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
            }
            
            
            ScrollView(.horizontal){
                HStack{
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
        }) {
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(width: 62, height: 89)
                .background{
                    movie.posterImage
                        .resizable()
                        .scaledToFit()
                        .clipped()
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(
                            vm.selectedMovie?.id == movie.id ? Color.loginBackgroundColor : Color.clear ,lineWidth: 2
                        )
                )
            
        }
    }
    
    
    
    private var movieTheaterList: some View {
        VStack(alignment: .leading){
            HStack{
                ForEach(vm.theaters, id: \.self) {theater in
                    Button {
                        vm.selectedTheater = theater
                        vm.canReserve = true
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(
                                    vm.selectedTheater == theater ? Color.loginBackgroundColor : .clear
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .inset(by: 0.5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .frame(width:55, height:35, alignment: .center)
                            Text(theater)
                                .font(.pretend(type: .semiBold, size: 16))
                                .foregroundStyle(
                                    vm.selectedTheater == theater ? .white : Color.textInGrayButtonColor)
                                .padding(10)
                        }
                    }
                    .disabled(vm.selectedMovie == nil)
                    .opacity(vm.selectedMovie == nil ? 0.3 : 1)
                }
            }.frame(maxWidth: .infinity , alignment: .leading)
            
        }
    }
    
    //MARK: - 캘린더 디테일 잚 모르겠음
    private var calendarSection: some View {
        VStack(spacing: 20) {
            HStack{
                let days = vm.calendarVM.daysForCurrentWeek()
                ForEach(days.indices, id: \.self) { index in
                    let day = days[index]
                    let isSelected = vm.calendarVM.calendar.isDate(day.date, inSameDayAs: vm.calendarVM.selectedDate)
                    VStack {
                        
                        // 날짜 표시
                        Text("\(day.day)")
                            .font(.pretend(type: .bold, size: 18))
                            .foregroundStyle(isSelected ? Color.white : Color.primary)
                            .foregroundStyle(day.isCurrentMonth ? Color.primary : Color.gray)
                            .onTapGesture {
                                vm.calendarVM.changeSelectedDate(day.date)
                            }
                        
                        // 요일 표시
                        Text(index == 0 ? "오늘" : index == 1 ? "내일" : localizedWeekdaySymbols[index])
                            .foregroundStyle(
                                isSelected ? Color.white :
                                    localizedWeekdaySymbols[index] == "일" ? Color.red :
                                    localizedWeekdaySymbols[index] == "토" ? Color.blue : Color.gray
                            )
                            .font(.pretend(type: .semiBold, size: 14))
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 4)
                    
                    .background{
                        RoundedRectangle(cornerRadius: 12) // 이미지처럼 둥근 사각형
                            .fill(isSelected ? Color.purple : Color.clear)
                    }
                    .disabled(vm.selectedTheater == nil)
                    .opacity(vm.selectedTheater == nil ? 0.3 : 1)
                    
                }
                
            }
            .padding(.horizontal)
        }
        
    }
    
    private var localizedWeekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        let symbols = formatter.shortWeekdaySymbols ?? []
        let calendar = Calendar.current // 오늘 날짜 가져오기
        let todayWeekdayIndex = calendar.component(.weekday, from: Date()) - 1 // 인덱스 정렬
        let rotated = Array(symbols[todayWeekdayIndex...] + symbols[..<todayWeekdayIndex]) //일주일 반환
        return rotated
    }
    
    //MARK: - 디테일
    
    private var selectDetailView: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            if vm.schedules.isEmpty {
                Text("선택한 극장에 상영시간표가 없습니다")
                    .font(.pretend(type:.semiBold, size:20))
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 50)
                
            } else {
                ForEach(vm.schedules) { schedule in
                    Text(schedule.theaterName)
                        .font(.pretend(type: .bold, size: 18))
                        .padding(.bottom, 5)
                    
                    let grouped = Dictionary(grouping: schedule.rooms, by: { $0.specialTheaterName ?? "일반관" })
                    
                    ForEach(grouped.keys.sorted(), id: \.self) { key in
                        Text(key)
                            .font(.pretend(type: .semiBold, size: 16))
                            .padding(.top, 5)
                            .padding(.bottom, 21)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                            ForEach(grouped[key] ?? []) { screening in
                                ScreeningTimeButton(screening: screening)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    private struct ScreeningTimeButton: View {
        let screening: ScreeningTime
        
        var body: some View {
            Button(action: {
                // 여기에 상영 시간 선택 로직 추가
                print("선택: \(screening.time) @ \(screening.specialTheaterName ?? "")")
            }) {
                VStack(alignment: .leading) {
                    // 시간
                    Text(screening.time)
                        .font(.pretend(type: .bold, size:18))
                        .foregroundStyle(.black)
                    
                    // 종료 시간
                    Text(screening.endTime)
                        .font(.pretend(type: .medium, size: 12))
                        .foregroundStyle(Color.textInGrayButtonColor)
                    
                    // 잔여 좌석 / 전체 좌석
                    HStack{
                        Text("\(screening.remainingSeats)")
                            .foregroundStyle(Color.loginBackgroundColor)
                            .multilineTextAlignment(.center)
                            .font(.pretend(type: .medium, size: 12))
                        Text("/ \(screening.totalSeats)")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.textInGrayButtonColor)
                            .font(.pretend(type: .medium, size: 14))
                    }
                    .padding(0)
                }
                
                .frame(minWidth:75, maxWidth: .infinity, minHeight: 70, maxHeight: .infinity)
                .padding(4)
                .background{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                }
            }
        }
    }
    
    
}

#Preview {
    
    // --- 1. 프리뷰 전용 "가짜" 영화 1개 만들기 ---
    // (이 MovieModel은 실제 앱의 MovieModel과 구조가 같아야 함)
    let fakeMovie = MovieModel(
        id: "m-001",
        title: "어쩔수가없다",
        posterImage: Image("어쩔수가없다"), // (Assets에 있는 이름)
        audience: 0,
        bookRanking: 0
    )
    
    // --- 2. 프리뷰에서 사용할 '공용 init'을 사용 ---
    // (이 뷰는 .task { } 에서 데이터를 로드하므로,
    //  프리뷰에서는 빈 화면으로 시작하는 것이 정상입니다.)
    return MovieReserveView(selectedMovie: fakeMovie)
}

