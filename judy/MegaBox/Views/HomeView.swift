import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @Namespace private var topNS
    @Namespace private var segNS

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {

                // 헤더
                HStack {
                    Image("homeLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Spacer()
                    Image(systemName: "bell")
                    Image(systemName: "magnifyingglass")
                }
                .padding(.top, 8)

                // 상단 4탭: 홈 / 이벤트 / 스토어 / 선호극장
                topTabBar

                // 타원형 세그먼트: 무비차트 / 상영예정
                segmentPills

                // 무비 카드 가로 스크롤
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 14) {
                        ForEach(vm.visibleMovies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieCardView(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .navigationTitle("홈")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Components
    private var topTabBar: some View {
        VStack(spacing: 8) {
            HStack(spacing: 20) {
                ForEach(HomeViewModel.TopTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            vm.selectedTopTab = tab
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Text(tab.rawValue)
                                .font(.pretendHeadline)
                                .foregroundStyle(vm.selectedTopTab == tab ? .primary : .secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.9)
                                .fixedSize(horizontal: true, vertical: false)

                            ZStack {
                                if vm.selectedTopTab == tab {
                                    Capsule()
                                        .matchedGeometryEffect(id: "TOP_UNDERLINE", in: topNS)
                                        .frame(height: 3)
                                } else {
                                    Color.clear.frame(height: 3)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
                Spacer(minLength: 0)
            }

            // 구분선
            Rectangle()
                .fill(Color.secondary.opacity(0.15))
                .frame(height: 1)
                .padding(.top, 4)
        }
    }

    private var segmentPills: some View {
        HStack(spacing: 12) {
            pill(for: .movieChart)
            pill(for: .comingSoon)
            Spacer()
        }
    }

    private func pill(for seg: HomeViewModel.Segment) -> some View {
        let isSelected = vm.selectedSegment == seg
        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                vm.selectedSegment = seg
            }
        } label: {
            Text(seg.rawValue)
                .font(.pretend(type: .medium, size: 16, relativeTo: .body))
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(isSelected ? Color("grey07") : Color("grey02"))
                        .shadow(color: Color.black.opacity(isSelected ? 0.12 : 0.06),
                                radius: isSelected ? 8 : 6, x: 0, y: 3)
                )
                .foregroundStyle(isSelected ? Color.white : Color("grey04"))
        }
        .buttonStyle(.plain)
    }
}
