import SwiftUI

struct ShowtimeSectionView: View {
    let sections: [(Theater, [ShowTime])]
    let shouldShow: Bool
    let selectedTheaters: Set<Theater>

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider().padding(.vertical, 4)

            if !shouldShow {
                Text("영화, 극장, 날짜를 모두 선택하면 상영관 정보가 표시됩니다.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(sections, id: \.0.id) { (theater, times) in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(theater.displayName)
                                .font(.headline).bold()
                            Spacer()
                            Button("극장안내") {}
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.4))
                                )
                        }
                        .padding(.horizontal)

                        if times.isEmpty {
                            Text("선택한 극장에 상영시간표가 없습니다.")
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.vertical, 16)
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                ForEach(times) { t in
                                    VStack(spacing: 6) {
                                        Text(t.time).font(.headline)
                                        Text(t.screen).font(.caption2)
                                        Text("잔여 \(t.seatsLeft)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3))
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                        }
                    }
                }
            }
        }
    }
}
