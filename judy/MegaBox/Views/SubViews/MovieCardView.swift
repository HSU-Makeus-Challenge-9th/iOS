import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(movie.posterHome)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(movie.titleKo)
                .font(.headline)
                .lineLimit(1)

            Text(movie.audience)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("예매")
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accentColor.opacity(0.15))
                )
        }
        .frame(width: 140)
        .contentShape(Rectangle())
    }
}
