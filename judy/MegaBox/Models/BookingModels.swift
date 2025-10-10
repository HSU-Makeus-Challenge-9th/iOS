import Foundation
import SwiftUI

struct MovieItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let imageName: String
    let ageBadge: String
}

enum Theater: String, CaseIterable, Identifiable {
    case gangnam = "강남"
    case hongdae = "홍대"
    case shinchon = "신촌"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .gangnam:  return "강남"
        case .hongdae:  return "홍대"
        case .shinchon: return "신촌"
        }
    }
}

struct DayItem: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let dayText: String
    let weekdayText: String
    let isToday: Bool
}

struct ShowTime: Identifiable, Equatable {
    let id = UUID()
    let time: String
    let screen: String
    let seatsLeft: Int
}
