//
//  Calendar.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-10-09.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

extension Calendar {
    static let current = Calendar.current
    static let gregorian = Calendar(identifier: .gregorian)
    static let iso8601 = Calendar(identifier: .iso8601)
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.iso8601) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.iso8601) -> Int {
        return calendar.component(component, from: self)
    }
    
    func startOfWeek(using calendar: Calendar = .iso8601) -> Date? {
        guard let sunday = self.getSunday() else { return nil }
        return sunday
    }
    
    func endOfWeek(using calendar: Calendar = .iso8601) -> Date? {
        guard let sunday = self.getSunday() else { return nil }
        return calendar.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func getSunday(using calendar: Calendar = .iso8601) -> Date? {        
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    
    func isSunday(using calendar: Calendar = .iso8601) -> Bool {
        guard let sunday = self.getSunday() else { return false }
        let dayStart = calendar.startOfDay(for: self)
        return dayStart == sunday
    }
    
    func nextWeek(using calendar: Calendar = .iso8601) -> Date? {
        return calendar.date(byAdding: .weekOfYear, value: 1, to: self)
    }
    
    func dayOfMonth(using calendar: Calendar = .iso8601) -> Int {
        return calendar.component(.day, from: self)
    }
    
    func weekday(using calendar: Calendar = .iso8601) -> Int {
        return calendar.component(.weekday, from: self)
    }
    
    func dayOfWeek() -> Int {
        let weekday = self.weekday()
        return weekday == 1 ? 8 : weekday
    }
    
    func weekOfYear(using calendar: Calendar = .iso8601) -> Int {
        return calendar.component(.weekOfYear, from: self)
    }
    
    func yearForWeekOfYear(using calendar: Calendar = .iso8601) -> Int {
        return calendar.component(.yearForWeekOfYear, from: self)
    }
    
    func lastWeekOfYear(for year: Int, month: Int = 12, day: Int = 31, using calendar: Calendar = .iso8601) -> Int? {
        let components = DateComponents(year: year, month: month, day: day)
        if let weekOfYear = calendar.date(from: components)?.weekOfYear() {
            if weekOfYear == 1 {
                return Date().lastWeekOfYear(for: year, month: month, day: day - 1)
            }
            return weekOfYear
        }
        return nil
    }
    
    func dateFrom(weekOfYear: Int, yearForWeekOfYear: Int, using celendar: Calendar = .iso8601) -> Date? {
        let componments = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: yearForWeekOfYear)
        return celendar.date(from: componments)
    }
    
    func dateFrom(weekday: Int, weekOfYear: Int, yearForWeekOfYear: Int, using celendar: Calendar = .iso8601) -> Date? {
        let componments = DateComponents(weekday: weekday, weekOfYear: weekOfYear, yearForWeekOfYear: yearForWeekOfYear)
        return celendar.date(from: componments)
    }
}

func weekRange(startOfWeek: Date, endOfWeek: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM-dd"
    
    return "\(dateFormatter.string(from: startOfWeek)) - \(dateFormatter.string(from: Calendar.iso8601.date(byAdding: .second, value: -1 ,to: endOfWeek) ?? endOfWeek))"
}
