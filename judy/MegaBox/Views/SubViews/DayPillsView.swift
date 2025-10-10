import SwiftUI

struct DayPillsView: View {
    let days: [DayItem]
    let selected: DayItem?
    let isEnabled: Bool
    var accent: Color = Color("purple03")
    let onTap: (DayItem) -> Void

    var body: some View {
        HStack(spacing: 18) {
            ForEach(days) { d in
                let active = d == selected
                VStack(spacing: 6) {
                    Text(d.dayText).font(.headline).bold()
                    Text(d.weekdayText).font(.caption)
                }
                .frame(width: 68, height: 72)
                .background(RoundedRectangle(cornerRadius: 14).fill(active ? accent : Color(.systemGray6)))
                .foregroundStyle(active ? .white : .primary)
                .opacity(isEnabled ? 1 : 0.4)
                .onTapGesture {
                    guard isEnabled else { return }
                    onTap(d)
                }
            }
        }
    }
}
