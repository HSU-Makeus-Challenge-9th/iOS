import SwiftUI

struct ReservationMenuView: View {
    var body: some View {
        HStack(spacing: 24) {
            ReservationItemView(imageName: "icon_movie",   title: "영화별예매")
            ReservationItemView(imageName: "icon_theater", title: "극장별예매")
            ReservationItemView(imageName: "icon_chair",   title: "특별관예매")
            ReservationItemView(imageName: "icon_popcorn", title: "모바일오더")
        }
        .padding(.top, 12)
    }
}

struct ReservationItemView: View {
    let imageName: String
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            Text(title)
                .font(.pretend(type: .regular, size: 12))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity)
    }
}
