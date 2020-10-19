//
//  Calendar.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-10-09.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date? {
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return calendar.date(byAdding: .day, value: 1, to: sunday)
    }
    
    func endOfWeek(using calendar: Calendar = .gregorian) -> Date? {
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return calendar.date(byAdding: .day, value: 8, to: sunday)
    }
}
