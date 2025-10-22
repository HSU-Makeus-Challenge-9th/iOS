import SwiftUI

struct MemberInfoFixedRow: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.pretend(type: .regular, size: 16))
            .foregroundStyle(.black)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.vertical, 12)
    }
}
