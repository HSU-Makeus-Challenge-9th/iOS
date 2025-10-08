import SwiftUI

struct MemberInfoNavBar: View {
    let title: String
    let backAction: () -> Void

    var body: some View {
        HStack {
            Button(action: backAction) {
                if UIImage(named: "navBack") != nil {
                    Image("navBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.black)

            Spacer()

            Text(title)
                .font(.pretend(type: .regular, size: 17))
                .foregroundStyle(.black)

            Spacer()

            Color.clear.frame(width: 24, height: 24)
        }
    }
}
