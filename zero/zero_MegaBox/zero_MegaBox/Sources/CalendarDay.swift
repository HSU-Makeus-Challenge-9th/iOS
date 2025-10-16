//
//  CalendarDay.swift
//  zero_MegaBox
//
//  Created by sumin Kong on 10/9/25.
//

import SwiftUI
import Foundation

struct CalendarDay: Identifiable {
    var id: UUID = .init()
    let day: Int
    let date: Date
    let isCurrentMonth: Bool
}
