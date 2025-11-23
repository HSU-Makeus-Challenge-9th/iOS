import SwiftUI

struct TheaterChangeBar: View {
    let theaterName: String
    let onTapChange: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "mappin.and.ellipse")
                .font(.subheadline)

            Text(theaterName)
                .font(.subheadline)
                .fontWeight(.semibold)

            Spacer()

            Button(action: onTapChange) {
                Text("극장 변경")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .strokeBorder(lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}
