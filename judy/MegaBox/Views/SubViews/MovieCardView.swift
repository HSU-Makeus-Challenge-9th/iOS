import SwiftUI

struct MovieCardView: View {
    let movie: AppMovie   // ✅ AppMovie로 통일

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // 포스터 이미지
            Image(movie.posterHome)
                .resizable()
                .scaledToFill()
                .frame(width: 148, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .clipped()

            // 바로 예매 버튼
            Button {
                // TODO: 예매 화면으로 네비게이션/시트 등 연결
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

            // 관람 등급/표시
            Text("\(movie.audience)세 이상 관람가")
                .font(.pretend(type: .regular, size: 15, relativeTo: .body))
                .foregroundColor(.primary)
        }
        .frame(width: 148)
        .contentShape(Rectangle())
    }
}
