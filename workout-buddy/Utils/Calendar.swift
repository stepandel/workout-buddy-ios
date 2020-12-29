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
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date? {
        guard let sunday = self.getSunday() else { return nil }
        if isSunday() {
            return calendar.date(byAdding: .day, value: -6, to: sunday)
        }
        return calendar.date(byAdding: .day, value: 1, to: sunday)
    }
    
    func endOfWeek(using calendar: Calendar = .gregorian) -> Date? {
        guard let sunday = self.getSunday() else { return nil }
        if isSunday() {
            return calendar.date(byAdding: .day, value: 1, to: sunday)
        }
        return calendar.date(byAdding: .day, value: 8, to: sunday)
    }
    
    func getSunday(using calendar: Calendar = .gregorian) -> Date? {
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    
    func isSunday(using calendar: Calendar = .gregorian) -> Bool {
        guard let sunday = self.getSunday() else { return false }
        let dayStart = calendar.startOfDay(for: self)
        return dayStart == sunday
    }
    
    func weekOfYear(using calendar: Calendar = .gregorian) -> Int {
        return calendar.component(.weekOfYear, from: self)
    }
    
    func yearForWeekOfYear(using calendar: Calendar = .gregorian) -> Int {
        return calendar.component(.yearForWeekOfYear, from: self)
    }
    
    func lastWeekOfYear(for year: Int, month: Int = 12, day: Int = 31, using calendar: Calendar = .gregorian) -> Int? {
        let components = DateComponents(year: year, month: month, day: day)
        if let weekOfYear = calendar.date(from: components)?.weekOfYear() {
            if weekOfYear == 1 {
                return Date().lastWeekOfYear(for: year, month: month, day: day - 1)
            }
            return weekOfYear
        }
        return nil
    }
}

func weekRange(startOfWeek: Date, endOfWeek: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM-dd"
    
    return "\(dateFormatter.string(from: startOfWeek)) - \(dateFormatter.string(from: Calendar.gregorian.date(byAdding: .second, value: -1 ,to: endOfWeek) ?? endOfWeek))"
}
