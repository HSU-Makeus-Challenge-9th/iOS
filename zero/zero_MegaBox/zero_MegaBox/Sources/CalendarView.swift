//
//  CalendarView.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/9/25.
//

import SwiftUI

struct Cell: View {
    
    var calendarDay: CalendarDay
    var isSelected: Bool
    @StateObject var viewModel: CalendarViewModel
    @ObservedObject var bookingViewModel: MovieViewModel
    
    var body: some View {
            ZStack {
                    Button(action: {
                        guard bookingViewModel.selectedTheaterName != nil else { return }
                        viewModel.changeSelectedDate(calendarDay.date)
                        bookingViewModel.selectedDate = calendarDay.date
                        bookingViewModel.isDaySelectable = true
                        print(viewModel.selectedDate)
                    }) {
                        VStack() {
                           Text("\(calendarDay.day)")
                               .font(.bold18)
                               .foregroundStyle(textColor)
                                       
                            if let labelText = todayLabel {
                               Text(labelText)
                                   .font(.semiBold14)
                                   .foregroundStyle(textColor)
                           }
                       }
                    }
                    .frame(width: 55, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                        .fill(buttonColor)
                    )
                    .disabled(bookingViewModel.selectedTheaterName == nil)
            }
    }
    
    private var textColor: Color {
        if isSelected {
            return Color("white")
        }
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: calendarDay.date)
        switch weekday {
            case 1:
                return .red
            case 7:
                return Color("tag")
            default:
                return .black
            }
    }
    private var buttonColor: Color {
        if isSelected {
            return Color("purple03")
        }
        else{
            return Color("white")
        }
    }

    private var todayLabel: String? {
        let calendar = Calendar.current
        let today = Date()
        if calendar.isDate(calendarDay.date, inSameDayAs: today) {
                    return "오늘"
                } else if calendar.isDate(calendarDay.date, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: today)!) {
                    return "내일"
                } else {
                    let weekday = calendar.component(.weekday, from: calendarDay.date)
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ko_KR")
                    return formatter.shortWeekdaySymbols[weekday - 1]
                }
    }
    
    
    
//    struct CalendarView: View {
//        
//        @StateObject var viewModel: CalendarViewModel = .init()
//        
//        var body: some View {
//            VStack(spacing: 24, content: {
//                hedarController // 상단 월 변경 컨트롤러
//                
//                calendarView // 달력 본체
//            })
//            .padding(.vertical, 30)
//            .padding(.horizontal, 16)
//            .background(Color.white)
//        }
//        
//        
//        /// 상단 월 변경 컨틀롤러 뷰
//        private var hedarController: some View {
//            HStack(spacing: 47, content: {
//                Button(action: {
//                    viewModel.changeMonth(by: -1)
//                }, label: {
//                    Image(systemName: "chevron.left")
//                })
//                
//                Text(viewModel.currentMonth, formatter: calendarHeaderDateFormatter)
//                    .font(.title3)
//                    .foregroundStyle(Color.black)
//                
//                
//                Button(action: {
//                    viewModel.changeMonth(by: 1)
//                }, label: {
//                    Image(systemName: "chevron.right")
//                })
//            })
//        }
//        
//        /// 달력 본체 뷰
//        private var calendarView: some View {
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 5, content: {
//                /// 요일 헤더 (일 ~ 토)
//                ForEach(localizedWeekdaySymbols.indices, id: \.self) { index in
//                    Text(localizedWeekdaySymbols[index])
//                        .foregroundStyle(index == 0 ? Color.red : index == 6 ? Color.blue : Color.gray) // 일요일, 토요일, 평일 색 따로 두기
//                        .frame(maxWidth: .infinity)
//                        .font(.caption)
//                }
//                .padding(.bottom, 30) // 요일 아래 여백
//                
//                ForEach(viewModel.daysForCurrentGrid(), id: \.id) { calendarDay in
//                    let isSelectedDate = viewModel.calendar.isDate(calendarDay.date, inSameDayAs: viewModel.selectedDate)
//                    Cell(calendarDay: calendarDay, isSelected: isSelectedDate, viewModel: viewModel)
//                    
//                }
//            })
//            .frame(height: 250, alignment: .top)
//        }
//        
//        /// 요일 이름 한글로 가져오기
//        let localizedWeekdaySymbols: [String] = {
//            let formatter = DateFormatter()
//            formatter.locale = Locale(identifier: "ko_KR")
//            return formatter.shortWeekdaySymbols ?? []
//        }()
//        
//        /// 헤더 날짜 표시 포맷터
//        let calendarHeaderDateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy.MM"
//            return formatter
//        }()
//    }
    
}
//
struct WeekCalendarView: View{
    @ObservedObject var viewModel: CalendarViewModel
    @ObservedObject var bookingViewModel: MovieViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekDates(), id: \.id) { day in
                let isSelected = Calendar.current.isDate(day.date, inSameDayAs: viewModel.selectedDate)
                Cell(calendarDay: day, isSelected: isSelected, viewModel: viewModel, bookingViewModel: bookingViewModel)
                    .opacity(viewModel.canSelectDate ? 1 : 0.4)
            }
        }
    }
    
    private func weekDates() -> [CalendarDay] {
        var days: [CalendarDay] = []
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                let dayNum = calendar.component(.day, from: date)
                days.append(CalendarDay(day: dayNum, date: date, isCurrentMonth: true))
            }
        }
        return days
    }
}


#Preview {
    WeekCalendarView(viewModel: CalendarViewModel(), bookingViewModel: MovieViewModel())
    
}
