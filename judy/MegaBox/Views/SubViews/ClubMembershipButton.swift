import SwiftUI

struct ClubMembershipButton: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Text("클럽 멤버십 >")
                    .font(.pretend(type: .semibold, size: 16))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [
                        Color("purple01"),
                        Color("blue02"),
                        Color("blue01")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
