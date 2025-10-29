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

// Subviews
extension MovieBookingView {
    private var movieSelectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(vm.selectedMovie?.audience ?? "15")
                    .font(.pretendCaption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                Text(vm.selectedMovie?.titleKo ?? "영화 선택")
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
                                .onTapGesture { vm.selectMovie(movie) }   // 선택 헬퍼 사용
                            
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
        VStack(alignment: .leading, spacing: 8) {
            if vm.theaters.isEmpty {
                Text("해당 영화의 상영 극장 정보가 없습니다.")
                    .font(.pretendCaption)
                    .foregroundStyle(.secondary)
            } else {
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
        }
    }
    
    private var dateSelectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if vm.availableDates.isEmpty {
                Text("해당 영화의 날짜 정보가 없습니다.")
                    .font(.pretendCaption)
                    .foregroundStyle(.secondary)
            } else {
                HStack(spacing: 18) {
                    ForEach(vm.availableDates, id: \.self) { date in
                        let cal = Calendar.current
                        let day = cal.component(.day, from: date)
                        let weekday = cal.component(.weekday, from: date)
                        let label = ["일","월","화","수","목","금","토"][weekday-1]
                        
                        // 날짜 색상
                        let textColor: Color = {
                            if weekday == 1 { return Color("red01") }
                            if weekday == 7 { return Color("green01") }
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
        }
    }

    private var showtimeSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            if vm.hasShowtime == false {
                Text("영화, 극장, 날짜를 모두 선택해주세요.")
                    .foregroundStyle(.secondary)
                    .padding(.top, 40)
            } else if vm.showtimeGroups.isEmpty {
                Text("선택한 조건에 해당하는 상영시간표가 없습니다.")
                    .foregroundStyle(.secondary)
                    .padding(.top, 40)
            } else {
                // JSON 기반 실제 상영정보
                ForEach(vm.showtimeGroups, id: \.hall) { group in
                    showtimeBlock(
                        theater: vm.selectedTheater ?? "",
                        hall: group.hall,
                        format: group.format,
                        shows: group.shows
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // BookingShowtime을 직접 받아 실제 좌석/시간 표시
    private func showtimeBlock(
        theater: String,
        hall: String,
        format: String,
        shows: [BookingShowtime]
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(theater)
                .font(.pretendHeadline)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(hall)
                        .font(.pretendBody)
                    Spacer()
                    Text(format)
                        .font(.pretendCaption)
                        .foregroundStyle(.secondary)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(shows) { s in
                            VStack(spacing: 4) {
                                Text(s.start)
                                    .font(.pretendSemiBold(14))
                                Text("\(s.available) / \(s.total)")
                                    .font(.pretendCaption)
                                    .foregroundColor(Color("purple03"))
                            }
                            .frame(width: 80, height: 60)
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
