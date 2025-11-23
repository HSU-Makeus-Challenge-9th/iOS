import SwiftUI
import Kingfisher
import UIKit

private enum DetailTab: Hashable { case info, review }

struct MovieDetailView: View {
    let movie: MovieDetail          // 상세에 필요한 데이터
    @State private var tab: DetailTab = .info
    @Environment(\.dismiss) private var dismiss

    private let sidePadding: CGFloat = 15
    private let underlineWidth: CGFloat = 120
    private let accent = Color("purple03")

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 상단 큰 포스터
                headerPoster

                // 내용
                VStack(alignment: .leading, spacing: 16) {

                    // 제목 / 원제
                    Text(movie.title)
                        .font(.system(size: 22, weight: .heavy))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    if !movie.englishTitle.isEmpty {
                        Text(movie.englishTitle)
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }

                    // 줄거리
                    Text(movie.description)
                        .font(.system(size: 15))
                        .foregroundStyle(.primary)
                        .lineSpacing(4)

                    // 탭 (상세 정보 / 실관람평)
                    VStack(spacing: 10) {
                        HStack {
                            Spacer()
                            tabLabel("상세 정보", isSelected: tab == .info)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        tab = .info
                                    }
                                }
                            Spacer()
                            tabLabel("실관람평", isSelected: tab == .review)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        tab = .review
                                    }
                                }
                            Spacer()
                        }

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.25)) // 회색 전체 라인
                                    .frame(height: 1)

                                Rectangle()
                                    .fill(Color.black) // 선택 탭 검은 언더라인
                                    .frame(width: underlineWidth, height: 2)
                                    .offset(x: underlineX(in: geo.size.width))
                            }
                        }
                        .frame(height: 2)
                    }
                    .padding(.top, 6)

                    // 탭 내용
                    Group {
                        switch tab {
                        case .info:
                            infoSection
                        case .review:
                            reviewSection
                        }
                    }
                }
                .padding(.horizontal, sidePadding)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .background(Color.white)
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image("Leading")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .accessibilityLabel("뒤로가기")
                }
            }
        }
    }

    // MARK: - 상단 큰 포스터

    private var headerPoster: some View {
        Group {
            if movie.posterName.hasPrefix("/") {
                // TMDB 경로인 경우 (예: "/abc123.jpg")
                KFImage(URL(string: "https://image.tmdb.org/t/p/w780" + movie.posterName))
                    .placeholder {
                        ZStack {
                            Rectangle().fill(Color.gray.opacity(0.1))
                            ProgressView()
                        }
                    }
                    .onFailure { _ in }
                    .resizable()
                    .scaledToFill()
            } else if UIImage(named: movie.posterName) != nil {
                // 앱 에셋 이미지인 경우
                Image(movie.posterName)
                    .resizable()
                    .scaledToFill()
            } else {
                // 없는 경우 플레이스홀더
                ZStack {
                    Rectangle().fill(Color.gray.opacity(0.12))
                    Image(systemName: "photo")
                        .font(.system(size: 28))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(height: 240)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    // MARK: - 탭 하단 언더라인 위치 계산

    private func underlineX(in fullWidth: CGFloat) -> CGFloat {
        let centerInfo = fullWidth * 0.25
        let centerReview = fullWidth * 0.75
        let half = underlineWidth / 2
        return (tab == .info ? centerInfo : centerReview) - half
    }

    private func tabLabel(_ title: String, isSelected: Bool) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .heavy))
            .foregroundStyle(isSelected ? .primary : .secondary)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    // MARK: - 탭별 섹션

    private var infoSection: some View {
        HStack(alignment: .top, spacing: 14) {
            smallPoster
                .frame(width: 96, height: 136)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 10) {
                Text("12세 이상 관람가")
                    .font(.system(size: 14, weight: .semibold))

                // 지금은 개봉일 정보가 없어서 텍스트만 예시로 둠
                Text("개봉일 정보 준비중")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.top, 12)
    }

    private var reviewSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(accent, lineWidth: 1.5)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.clear))
            Text("등록된 관람평이 없어요 🥲")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .padding(.top, 12)
    }

    // MARK: - 작은 포스터 (상세 정보 탭 왼쪽)

    private var smallPoster: some View {
        Group {
            if movie.posterName.hasPrefix("/") {
                KFImage(URL(string: "https://image.tmdb.org/t/p/w342" + movie.posterName))
                    .placeholder {
                        ZStack {
                            Rectangle().fill(Color.gray.opacity(0.1))
                            ProgressView()
                        }
                    }
                    .onFailure { _ in }
                    .resizable()
                    .scaledToFill()
            } else if UIImage(named: movie.posterName) != nil {
                Image(movie.posterName)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.12))
                    Image(systemName: "photo").foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - 프리뷰용 더미 데이터

#Preview {
    NavigationStack {
        MovieDetailView(
            movie: MovieDetail(
                title: "F1 더 무비",
                englishTitle: "F1: The Movie",
                posterName: "amovie",          // 또는 "/abc123.jpg" 같은 TMDB 경로
                description: "예시 설명 텍스트입니다."
            )
        )
    }
}

