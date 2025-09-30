import SwiftUI

struct MemberInfoEditableRow: View {
    let placeholder: String
    @Binding var text: String
    let onTapChange: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(.pretend(type: .regular, size: 16))
                .foregroundStyle(.black)

            Button(action: onTapChange) {
                Text("변경")
                    .font(.pretend(type: .regular, size: 12))
                    .foregroundStyle(Color("grey03"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color("grey03"), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 12)
    }
}
