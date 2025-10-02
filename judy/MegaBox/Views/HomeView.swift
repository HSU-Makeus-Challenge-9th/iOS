import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @Namespace private var segNS

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // 헤더
                HStack {
                    Image("megaboxLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Spacer()
                    Image(systemName: "bell")
                    Image(systemName: "magnifyingglass")
                }
                .padding(.top, 8)

                // 세그먼트
                HStack(spacing: 16) {
                    ForEach(HomeViewModel.Segment.allCases, id: \.self) { seg in
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                vm.selectedSegment = seg
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Text(seg.rawValue)
                                    .font(.headline)
                                    .foregroundStyle(vm.selectedSegment == seg ? .primary : .secondary)

                                if vm.selectedSegment == seg {
                                    Capsule()
                                        .matchedGeometryEffect(id: "SEG_UNDERLINE", in: segNS)
                                        .frame(height: 3)
                                } else {
                                    Color.clear.frame(height: 3)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }

                // 무비 카드 가로 스크롤
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 14) {
                        ForEach(vm.visibleMovies) { movie in
                            NavigationLink(
                                destination: MovieDetailView(movie: movie)
                            ) {
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
}
