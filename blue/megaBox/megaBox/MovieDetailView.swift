import SwiftUI

struct MovieDetailView: View {
    let movie: MovieDetail
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: Int = 0   // 0 = 상세정보, 1 = 실관람평
    
    var body: some View {
        VStack(spacing: 10) {
            
            // 상단 네비게이션
            ZStack {
                Text(movie.title)
                    .font(.system(size: 16, weight: .semibold))
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    Image(movie.posterName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight: 248, maxHeight: 248)
                        .clipped()
                    
                    VStack(spacing: 4) {
                        Text(movie.title)
                            .font(.system(size: 24, weight: .bold))
                        Text(movie.englishTitle)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                    
                    Text(movie.description)
                        .font(.system(size: 14))
                        .foregroundColor(Color("gray03"))
                        .lineSpacing(4)
                        .padding(.horizontal, 1)
                        .padding(.top, 12)
                    
                    HStack {
                        Button {
                            selectedTab = 0
                        } label: {
                            VStack {
                                Text("상세 정보")
                                    .font(.system(size: 20, weight: selectedTab == 0 ? .bold : .regular))
                                    .foregroundColor(selectedTab == 0 ? .black : Color("gray02"))
                                Rectangle()
                                    .fill(selectedTab == 0 ? Color.black : Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        
                        Button {
                            selectedTab = 1
                        } label: {
                            VStack {
                                Text("실관람평")
                                    .font(.system(size: 20, weight: selectedTab == 1 ? .bold : .regular))
                                    .foregroundColor(selectedTab == 1 ? .black : Color("gray02"))
                                Rectangle()
                                    .fill(selectedTab == 1 ? Color.black : Color.clear)
                                    .frame(height: 2)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 35)
                    
                    Group {
                        if selectedTab == 0 {
                            VStack(alignment: .leading, spacing: 12) {
                                // ✅ alignment: .top 추가
                                HStack(alignment: .top, spacing: 12) {
                                    Image("c2movie")
                                        .resizable()
                                        .frame(width: 100, height: 120)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("12세 이상 관람가")
                                            .font(.system(size: 13))
                                        Text("2025.06.25 개봉")
                                            .font(.system(size: 13))
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        } else {
                            VStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("purple02"))
                                    .frame(maxWidth: .infinity, minHeight: 120)
                                    .overlay(
                                        Text("등록된 관람평이 없어요 😢")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color("gray08"))
                                    )
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

extension MovieDetail {
    static let preview = MovieDetail(
        title: "F1 더 무비",
        englishTitle: "F1: The Movie",
        posterName: "c1movie",
        description:
        """
        최고가 되지 못한 전설 VS 최고가 되고 싶은 루키

        한때 주목받는 유망주였지만 끔찍한 사고로 F1에서 우승하지 못하고,
        한순간에 추락한 드라이버 ‘숀 헤이스’(브래드 피트).
        그의 오랜 동료이자 루키 ‘루벤 세리반테스’(하비에르 바르뎀)와 함께
        레이싱 복귀를 제안받으며 최하위 팀인 APXGP에 합류한다.
        """
    )
}

#Preview {
    NavigationStack { MovieDetailView(movie: .preview) }
}
