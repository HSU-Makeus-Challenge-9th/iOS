import SwiftUI

struct TheaterChangeBar: View {
    let theaterName: String
    let onTapChange: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            // 핀 아이콘
            Image("pin")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundColor(.white)

            // 지역명
            Text(theaterName)
                .font(
                    Font.custom("Pretendard", size: 15)
                        .weight(.semibold)
                )
                .foregroundColor(.white)

            Spacer()

            // 극장 변경 버튼
            Button(action: onTapChange) {
                Text("극장 변경")
                    .font(
                        Font.custom("Pretendard", size: 13)
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        Capsule()
                            .stroke(Color.white, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Color("purple03")
        )
    }
}
