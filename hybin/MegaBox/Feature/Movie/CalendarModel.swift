//
//  CalendarModel.swift
//  MegaBox
//
//  Created by 전효빈 on 10/9/25.
//

import Foundation
import SwiftUI

struct CalendarDay: Identifiable {
    var id: UUID = .init()
    let day: Int
    let date: Date
    let isCurrentMonth: Bool
}
