import SwiftUI

struct StatusInfoView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            StatusItemView(title: "쿠폰", count: 2)
            Divider().frame(height: 40)
            StatusItemView(title: "스토어 교환권", count: 0)
            Divider().frame(height: 40)
            StatusItemView(title: "모바일 티켓", count: 0)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("grey02"), lineWidth: 1)
        )
    }
}

struct StatusItemView: View {
    let title: String
    let count: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.pretend(type: .semibold, size: 18))
                .foregroundStyle(.black)
            Text(title)
                .font(.pretend(type: .regular, size: 12))
                .foregroundStyle(Color("grey04"))
        }
        .frame(maxWidth: .infinity)
    }
}
