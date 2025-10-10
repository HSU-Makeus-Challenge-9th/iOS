import SwiftUI

struct OutlineChipStyle: ButtonStyle {
    var width: CGFloat = 69
    var height: CGFloat = 30

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 0) {
            configuration.label
                .font(.custom("Pretendard-Medium", size: 12))
                .foregroundColor(.primary)
        }
        .padding(10)
        .frame(width: width, height: height, alignment: .center)
        .background(Color(uiColor: .systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
        .cornerRadius(8)
        .opacity(configuration.isPressed ? 0.7 : 1)
        .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        .contentShape(RoundedRectangle(cornerRadius: 8))
    }
}
