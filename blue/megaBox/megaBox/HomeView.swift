//
//  HomeView.swift
//  megaBox
//
//  Created by 은재 on 10/1/25.
//

import SwiftUI

private enum ChartTab: String {
    case movieChart = "무비차트"
    case comingSoon = "상영예정"
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedDetail: MovieDetail?
    @State private var selectedTab: ChartTab = .movieChart

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 8) {
                    headerSection
                        .padding(.bottom, 6)
                    movieCardSection
                    movieFeedSection
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationDestination(item: $selectedDetail) { detail in
                MovieDetailView(movie: detail)
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image("meboxLogo 1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Spacer()
            }

            HStack(spacing: 27) {
                Text("홈")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                Text("이벤트")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color("gray04"))
                Text("스토어")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color("gray04"))
                Text("선호극장")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color("gray04"))
            }
        }
    }

    private var movieCardSection: some View {
        VStack(alignment: .leading, spacing: 17) {

            HStack(spacing: 23) {
                chip(title: ChartTab.movieChart.rawValue, isSelected: selectedTab == .movieChart) {
                    selectedTab = .movieChart
                }
                chip(title: ChartTab.comingSoon.rawValue, isSelected: selectedTab == .comingSoon) {
                    selectedTab = .comingSoon
                }
            }
            .padding(.top, 0)

            // 가로 스크롤 카드
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 24) {
                  
                    ForEach(viewModel.movies, id: \.id) { movie in
                        VStack(alignment: .leading, spacing: 8) {

                            ZStack(alignment: .topLeading) {
                                if let name = movie.posterName {
                                    Image(name)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.2))
                                        .overlay(Image(systemName: "photo"))
                                }

                                if let badge = movie.badge, !badge.isEmpty {
                                    Text(badge)
                                        .font(.system(size: 12, weight: .heavy))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.white.opacity(0.95))
                                        .clipShape(Capsule())
                                        .padding(6)
                                }
                            }
                            .frame(width: 148, height: 212)
                            .clipShape(RoundedRectangle(cornerRadius: 0))
                            .contentShape(Rectangle())
                            .onTapGesture {

                                if movie.title == "F1 더 무비" {
                                    selectedDetail = MovieDetail(
                                        title: movie.title,
                                        englishTitle: "F1: The Movie",
                                        posterName: "c1movie",
                                        description:
"""
최고가 되기 위한 절정 VS 최고가 되고 싶은 루키

포뮬러 원 유망주였던 조반예가 극적 사고로 F1에서 우승하지 못하고...
레이싱의 찰나와 승부의 운명을 담아낸 스포트 다큐드라마.
"""
                                    )
                                }
                            }

                            Button {
                        
                            } label: {
                                Text("바로 예매")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color("purple03"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 9)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("purple03"), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)

                            // 제목
                            Text(movie.title)
                                .font(.system(size: 19, weight: .bold))
                                .foregroundColor(.black)
                                .lineLimit(1)

                            // 부제/관객수
                            Text(movie.audience)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                        }
                        .frame(width: 148)
                    }
                }
                .padding(.trailing, 2)
            }
        }
    }

    private func chip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(isSelected ? .white : Color("gray04"))
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color("gray08") : Color("gray02"))
                )
        }
        .buttonStyle(.plain)
    }

    private var movieFeedSection: some View {
        VStack(alignment: .leading, spacing: -10) {
            HStack {
                Text("알고보면 더 재밌는 무비피드")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                Spacer()
                Image("liquidButton")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .contentShape(Rectangle())
            }
            .padding(.top, -15)

            FeedHero(imageName: "dmovie")
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))

            VStack(spacing: 18) {
                ForEach(viewModel.articles, id: \.id) { article in
                    ArticleRow(article: article)
                }
            }
            .padding(.top, 30)
        }
    }
}

private struct FeedHero: View {
    let imageName: String?
    var body: some View {
        ZStack {
            if let n = imageName, UIImage(named: n) != nil {
                Image(n).resizable().scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.15))
                    .overlay(Image(systemName: "photo"))
            }
        }
    }
}

private struct ArticleRow: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                if let name = article.thumbnailName, UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.12))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.secondary)
                        )
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 20) {
                Text(article.title)
                    .font(.system(size: 15, weight: .semibold))

                if !article.subtitle.isEmpty {
                    Text(article.subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
