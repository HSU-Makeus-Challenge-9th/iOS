import SwiftUI

struct TheaterChipsView: View {
    let selected: Set<Theater>
    let isEnabled: Bool
    var accent: Color = Color("purple03")
    let onTap: (Theater) -> Void

    var body: some View {
        HStack(spacing: 12) {
            ForEach(Theater.allCases) { th in
                let active = selected.contains(th)
                Button {
                    guard isEnabled else { return }
                    onTap(th)
                } label: {
                    Text(th.rawValue)
                        .font(.subheadline).bold()
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(Capsule().fill(active ? accent : Color(.systemGray6)))
                        .foregroundStyle(active ? .white : .primary)
                        .opacity(isEnabled ? 1 : 0.4)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
