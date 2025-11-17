import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    enum Segment: String { case detail = "상세 정보", review = "실관람평" }

    let movie: AppMovie
    @Environment(\.dismiss) private var dismiss
    @State private var seg: Segment = .detail
    @Namespace private var ns

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.title3.weight(.semibold))
                }
                Text(movie.titleKo).font(.pretendHeadline)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {

                    // 상단 대형 포스터: backdrop → poster → 에셋 순
                    Group {
                        if let url = movie.backdropURL ?? movie.posterURL {
                            KFImage(url)
                                .placeholder { ProgressView() }
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(movie.posterDetail.isEmpty ? movie.posterHome : movie.posterDetail)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipped()

                    VStack(alignment: .leading, spacing: 6) {
                        Text(movie.titleKo).font(.pretendTitle)
                        Text(movie.titleEn)   // original_title
                            .font(.pretendCaption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)

                    if !movie.overview.isEmpty {
                        Text(movie.overview)
                            .font(.pretendBody)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                    }

                    segmentBar

                    Group {
                        if seg == .detail { detailSection } else { reviewSection }
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 24)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(Color(.systemBackground))
    }

    private var segmentBar: some View {
        GeometryReader { proxy in
            let totalWidth = proxy.size.width
            let hPad: CGFloat = 16
            let segmentWidth = (totalWidth - hPad * 2) / 2
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    segButton(.detail).frame(width: segmentWidth)
                    segButton(.review).frame(width: segmentWidth)
                }
                .padding(.horizontal, hPad)
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color.secondary.opacity(0.15))
                        .frame(height: 1)
                        .padding(.horizontal, hPad)
                    Capsule().fill(Color.primary)
                        .frame(width: segmentWidth, height: 3)
                        .offset(x: hPad + (seg == .detail ? 0 : segmentWidth))
                        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: seg)
                }
            }
        }
        .frame(height: 44)
        .padding(.top, 8)
    }

    @ViewBuilder
    private func segButton(_ target: Segment) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) { seg = target }
        } label: {
            Text(target.rawValue)
                .font(.pretendHeadline)
                .foregroundStyle(seg == target ? .primary : .secondary)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var detailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {

                // 작은 포스터: TMDB 우선, 없으면 에셋
                Group {
                    if let url = movie.posterURL {
                        KFImage(url)
                            .placeholder { ProgressView() }
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(movie.posterHome)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 92, height: 92)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text("\(movie.audience)세 이상 관람가")
                        .font(.pretendBody)

                    if !movie.releaseDate.isEmpty {
                        Text(movie.releaseDate)
                            .font(.pretendBody)
                    }
                }
                Spacer()
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
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
                        .font(.pretendCaption)
                        .foregroundStyle(.secondary)
                )
        }
        .padding(.top, 8)
    }
}
