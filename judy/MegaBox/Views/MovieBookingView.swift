import SwiftUI

struct MovieBookingView: View {
    @StateObject private var vm = BookingViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    movieSelectionSection
                    theaterSelectionSection
                    dateSelectionSection
                    
                    Divider()
                    
                    showtimeSection
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("영화별 예매")
                        .font(.pretendSemiBold(17, relativeTo: .headline))
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color("purple03"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(isPresented: $vm.showSearchSheet) {
                MovieSearchView(vm: vm)
            }
        }
    }
}

// SubViews
extension MovieBookingView {
    private var movieSelectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("15")
                    .font(.pretendCaption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                Text(vm.selectedMovie?.titleKo ?? "어쩔수가없다")
                    .font(.pretendHeadline)
                
                Spacer()
                
                Button {
                    vm.showSearchSheet = true
                } label: {
                    Text("전체영화")
                        .font(.pretendSemiBold(14, relativeTo: .footnote))
                        .foregroundStyle(.primary)
                }
                .buttonStyle(OutlineChipStyle())
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(vm.movies) { movie in
                        VStack(spacing: 6) {
                            Image(movie.posterHome)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 140)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(vm.selectedMovie == movie ? Color("purple03") : .clear, lineWidth: 3)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture { vm.selectedMovie = movie }
                            
                            Text(movie.titleKo)
                                .font(.pretendCaption)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .frame(width: 100)
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    private var theaterSelectionSection: some View {
        HStack(spacing: 10) {
            ForEach(vm.theaters, id: \.self) { theater in
                let isOn = (vm.selectedTheater == theater)
                Button {
                    guard vm.selectedMovie != nil else { return }
                    vm.selectedTheater = theater
                } label: {
                    Text(theater)
                        .font(.pretendBody)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(isOn ? Color("purple03") : Color.gray.opacity(0.2))
                        .foregroundColor(isOn ? .white : .primary)
                        .clipShape(Capsule())
                }
                .disabled(vm.selectedMovie == nil)
                .opacity(vm.selectedMovie == nil ? 0.4 : 1.0)
            }
        }
    }
    
    private var dateSelectionSection: some View {
        HStack(spacing: 18) {
            ForEach(vm.weekDates, id: \.self) { (date: Date) in
                let cal = Calendar.current
                let day = cal.component(.day, from: date)
                let weekday = cal.component(.weekday, from: date) // 1=일, 7=토
                let label = cal.isDateInToday(date) ? "오늘" : ["일","월","화","수","목","금","토"][weekday-1]
                
                // 날짜 색상
                let textColor: Color = {
                    if cal.isDateInToday(date) { return Color("purple03") }
                    if weekday == 1 { return Color("red01") }      // 일요일
                    if weekday == 7 { return Color("green01") }    // 토요일
                    return .primary
                }()
                
                Button {
                    guard vm.selectedTheater != nil else { return }
                    vm.selectedDate = date
                } label: {
                    VStack(spacing: 4) {
                        Text("\(day)")
                            .font(.pretendSemiBold(14))
                            .foregroundColor(textColor)
                        Text(label)
                            .font(.pretendCaption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(10)
                    .background(vm.selectedDate == date ? Color("purple03").opacity(0.15) : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(vm.selectedTheater == nil)
                .opacity(vm.selectedTheater == nil ? 0.4 : 1.0)
            }
        }
    }

    private var showtimeSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            if vm.hasShowtime {
                if vm.selectedTheater == "신촌" {
                    Text("선택한 극장에 상영시간표가 없습니다.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 40)
                } else {
                    if vm.selectedTheater == "강남" {
                        showtimeBlock(theater: "강남", halls: [
                            ("크리클라이터 1관", ["11:30", "14:20", "17:05", "19:45", "22:20"])
                        ])
                    } else if vm.selectedTheater == "홍대" {
                        showtimeBlock(theater: "홍대", halls: [
                            ("BTS관 (7층 1관 [Laser])", ["9:30", "12:00", "14:45"]),
                            ("BTS관 (9층 2관 [Laser])", ["11:30", "14:10", "16:50", "19:20"])
                        ])
                    }
                }
            } else {
                Text("영화, 극장, 날짜를 모두 선택해주세요.")
                    .foregroundStyle(.secondary)
                    .padding(.top, 40)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func showtimeBlock(theater: String, halls: [(String, [String])]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(theater)
                .font(.pretendHeadline)
            
            ForEach(halls, id: \.0) { hall, times in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(hall)
                            .font(.pretendBody)
                        Spacer()
                        Text("2D")
                            .font(.pretendCaption)
                            .foregroundStyle(.secondary)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(times, id: \.self) { time in
                                VStack(spacing: 4) {
                                    Text(time)
                                        .font(.pretendSemiBold(14))
                                    Text("\(Int.random(in: 1...116)) / 116")
                                        .font(.pretendCaption)
                                        .foregroundColor(Color("purple03"))
                                }
                                .frame(width: 70, height: 60)
                                .background(Color(uiColor: .systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                            }
                        }
                    }
                }
            }
        }
    }
}
