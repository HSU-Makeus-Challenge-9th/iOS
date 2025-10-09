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
    @State var calendarVM = CalendarViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body : some View {
        VStack{
            header
            movieList
                .padding(.horizontal , 16)
                .padding(.top , 10)
                .padding(.bottom, 32)
            movieTheaterList
                .padding(.horizontal , 16)
            calendarSection
            if vm.canReserve {
                selectDetailView
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    //MARK: 하위뷰
    private var header: some View {
        ZStack {
            
            Text("영화별 예매")
                .font(.pretend(type: .bold, size: 22))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
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
                
                Text("전체영화")
                    .font(.pretend(type: .semiBold, size: 14))
                    .padding(0)
                    .frame(width: 69, height: 30 , alignment:.center)
                    .background(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
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
    //MARK: - UI디테일 수정 필요
    private var calendarSection: some View {
        VStack(spacing: 20) {
            HStack{
                let days = calendarVM.daysForCurrentWeek()
                ForEach(days.indices, id: \.self) { index in
                    let day = days[index]
                    let isSelected = calendarVM.calendar.isDate(day.date, inSameDayAs: calendarVM.selectedDate)
                    VStack {
                        
                        // 요일 표시
                        Text(index == 0 ? "오늘" : index == 1 ? "내일" : localizedWeekdaySymbols[index])
                            .foregroundStyle(
                                isSelected ? Color.white :
                                    localizedWeekdaySymbols[index] == "일" ? Color.red :
                                    localizedWeekdaySymbols[index] == "토" ? Color.blue : Color.gray
                            )
                            .font(.caption)
                        
                        
                        // 날짜 표시
                        Text("\(day.day)")
                            .foregroundStyle(isSelected ? Color.white : Color.primary)
                            .foregroundStyle(day.isCurrentMonth ? Color.primary : Color.gray)
                            .onTapGesture {
                                calendarVM.changeSelectedDate(day.date)
                            }
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
    //MARK: - UI 디테일 수정 필요
    
    private var selectDetailView: some View {
        // Spacer()가 필요 없으므로 VStack(alignment: .leading) 안에 넣습니다.
        VStack(alignment: .leading, spacing: 10) {
            
            // 1. 모든 조건이 충족되지 않거나, 오늘 날짜가 아니거나, 신촌을 선택했을 때 메시지 표시
            if calendarVM.calendar.isDateInToday(calendarVM.selectedDate) == false || vm.selectedMovie == nil || vm.selectedTheater == nil || vm.selectedTheater == "신촌" {
                
                // 신촌을 선택했거나, 날짜/영화/극장이 선택되지 않은 경우 이 메시지를 표시
                Text("선택한 극장에 상영시간표가 없습니다")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 50)
                
                
            } else {
                // 2. 상영 시간표 표시
                ForEach(vm.filteredSchedules) { schedule in
                    // 극장 이름 표시 (예: 강남)
                    Text(schedule.theaterName)
                        .font(.title3.weight(.bold))
                        .padding(.bottom, 5)
                    
                    // 상영 시간표 그리드
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                        
                        // 해당 극장의 모든 상영 시간표를 표시
                        ForEach(schedule.rooms) { screening in
                            // 상영 시간 버튼
                            ScreeningTimeButton(screening: screening)
                        }
                    }
                    .padding(.bottom, 20)
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
                VStack(spacing: 4) {
                    // 시간
                    Text(screening.time)
                        .font(.title3.weight(.bold))
                        .foregroundColor(.primary)
                    
                    // 종료 시간
                    Text(screening.endTime)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // 잔여 좌석 / 전체 좌석
                    Text("\(screening.remainingSeats) / \(screening.totalSeats)")
                        .font(.caption)
                        .foregroundColor(screening.remainingSeats < 10 ? .red : .blue) // 잔여석에 따라 색상 변경
                }
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
    }
    
    
}

#Preview {
    MovieReserveView(vm: MovieReserveViewModel(homeVM:HomeViewModel()))
}
