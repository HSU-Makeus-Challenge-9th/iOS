import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 포스터 이미지
            Image(movie.posterHome)
                .resizable()
                .scaledToFill()
                .frame(width: 148, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .clipped()

            // 바로 예매 버튼
            Button {
            } label: {
                Text("바로 예매")
                    .font(.pretend(type: .medium, size: 16, relativeTo: .body))
                    .tracking(-0.8)
                    .frame(maxWidth: .infinity, minHeight: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("purple03"), lineWidth: 1)
                            )
                    )
                    .foregroundColor(Color("purple03"))
            }
            .buttonStyle(.plain)

            // 영화 제목
            Text(movie.titleKo)
                .font(.pretend(type: .semibold, size: 21, relativeTo: .body))
                .lineLimit(1)
                .foregroundColor(.primary)

            // 관객 수
            Text(movie.audience)
                .font(.pretend(type: .regular, size: 15, relativeTo: .body))
                .foregroundColor(.primary)
        }
        .frame(width: 148)
        .contentShape(Rectangle())
    }
}
