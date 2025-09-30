import SwiftUI

struct MemberInfoBasicTitle: View {
    var body: some View {
        Text("기본정보")
            .font(.pretend(type: .semibold, size: 18))
            .foregroundStyle(.black)
    }
}

#Preview { MemberInfoBasicTitle() }
