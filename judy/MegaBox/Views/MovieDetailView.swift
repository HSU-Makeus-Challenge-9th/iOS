import SwiftUI

struct MovieDetailView: View {
    enum Segment: String { case detail = "상세 정보", review = "실관람평" }

    let movie: Movie
    @Environment(\.dismiss) private var dismiss
    @State private var seg: Segment = .detail
    @Namespace private var ns

    var body: some View {
        VStack(spacing: 0) {
            // 커스텀 네비 바
            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
                }
                Text(movie.titleKo)
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    // 포스터 (오타 수정: .scaledToFill())
                    Image(movie.posterDetail)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipped()

                    // 타이틀
                    VStack(alignment: .leading, spacing: 6) {
                        Text(movie.titleKo)
                            .font(.title2.bold())
                        Text(movie.titleEn)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)

                    // 영화 설명 직접 작성
                    Text("""
                    최고가 되지 못한 전설 VS 최고가 되고 싶은 루키
                    
                    한때 주목받는 유망주였지만 끔찍한 사고로 F1에서 우승하지 못하고
                    한순간에 추락한 드라이버 ‘숀 헤이스’(브레드 피트).
                    그의 오랜 동료인 ‘루벤 세르반테스’(하비에르 바르뎀)에게 
                    레이싱 복귀를 제안받으며 최하위 팀인 APGXP에 합류한다.
                    """)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)

                    // 세그먼트
                    segmentBar

                    // 컨텐츠
                    Group {
                        if seg == .detail {
                            detailSection
                        } else {
                            reviewSection
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 24)
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color(.systemBackground))
    }

    private var segmentBar: some View {
        VStack(spacing: 8) {
            HStack(spacing: 20) {
                segButton(.detail)
                segButton(.review)
                Spacer()
            }
            .padding(.horizontal, 16)

            // 하단 라인 + 인디케이터
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.secondary.opacity(0.15))
                    .frame(height: 1)
                    .padding(.horizontal, 16)

                HStack(spacing: 0) {
                    Spacer().frame(width: 16)
                    Capsule()
                        .fill(Color.primary)
                        .frame(width: 60, height: 3) // 버튼 폭과 무관하게 깔끔
                        .offset(x: seg == .detail ? 0 : 80)
                        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: seg)
                    Spacer()
                }
            }
        }
        .padding(.top, 8)
    }

    @ViewBuilder
    private func segButton(_ target: Segment) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                seg = target
            }
        } label: {
            Text(target.rawValue)
                .font(.headline)
                .foregroundStyle(seg == target ? .primary : .secondary)
                .padding(.vertical, 6)
                .background(
                    Group {
                        if seg == target {
                            Color.clear.matchedGeometryEffect(id: "SEG_HIT", in: ns)
                        }
                    }
                )
        }
        .buttonStyle(.plain)
    }

    private var detailSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            // 썸네일 + 정보 카드
            HStack(alignment: .top, spacing: 12) {
                Image(movie.posterHome)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 92, height: 92)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 8) {
                    Text("12세 이상 관람가")
                        .font(.subheadline)
                        .foregroundStyle(.primary)

                    Text("2025.06.25 개봉")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
            )
        }
        .padding(.top, 8)
    }


    private var reviewSection: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.secondary.opacity(0.25), lineWidth: 1)
                .frame(maxWidth: .infinity, minHeight: 120)
                .overlay(
                    Text("등록된 관람평이 없어요 🥲")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                )
        }
        .padding(.top, 8)
    }
}
