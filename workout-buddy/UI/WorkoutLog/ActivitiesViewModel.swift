//
//  ActivitiesViewModel.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-15.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

extension Activities {
    class ViewModel: ObservableObject {
        
        // State
        @Published var workoutLog: [WorkoutWeek]
        
        // Misc
        let appState: AppState
        private let dateFormatter = DateFormatter()
        var workoutLogItems: [WorkoutLogItem]
        
        init(appState: AppState) {
            self.appState = appState
            self.workoutLogItems = appState.userData.workoutLog
            self.workoutLog = []
            if let nextWeekDate = Date().nextWeek() { // Start from next week
                var curWeek = nextWeekDate.weekOfYear()
                var curWeekYear = nextWeekDate.yearForWeekOfYear()
                var weekIdx = 0
                self.workoutLogItems.reversed().forEach { workout in
                    
                    // Skip workouts scheduled past next week
                    if let nextWeek = Calendar.iso8601.date(byAdding: .weekOfYear, value: 1, to: Date()) {
                        if let nextWeekSunday = nextWeek.endOfWeek() {
                            if workout.startTS < nextWeekSunday.timeIntervalSince1970 {
                                (curWeek, curWeekYear, weekIdx) = self.workoutLog.addToLog(curWeek: curWeek, curWeekYear: curWeekYear, workout: workout, at: weekIdx)
                            }
                        }
                    }
                }
                // For new users
                if self.workoutLog.isEmpty {
                    self.workoutLog.append(WorkoutWeek(id: 0))
                }
            }
        }
        
        func deleteWorkout(wokroutLogItem: WorkoutLogItem, weekIdx: Int) {
            self.appState.deleteWorkoutLogItem(workoutLogItem: wokroutLogItem)
            if let wlIdx = self.workoutLogItems.firstIndex(of: wokroutLogItem) {
                self.workoutLogItems.remove(at: wlIdx)
            }
            if let (day, i) = self.workoutLog[weekIdx].items.indices(of: wokroutLogItem) {
                self.workoutLog[weekIdx].items[day].remove(at: i)
            }
        }
        
        func weekStr(weekIdx: Int) -> String {
            
            if self.workoutLog[weekIdx].id == 0 {
                return "Next Week"
            }
            
            if self.workoutLog[weekIdx].id == 1 {
                return "This Week"
            }
            
            let today = Date()
            let weekDay = Calendar.gregorian.date(byAdding: .day, value: -(weekIdx-1)*7, to: today)
            
            if let startOfWeek = weekDay?.startOfWeek(), let endOfWeek = weekDay?.endOfWeek() {
                return weekRange(startOfWeek: startOfWeek, endOfWeek: endOfWeek)
            }

            return "Week ???"
        }
        
        func getWeekDayStr(timestamp: Double) -> String {
            self.dateFormatter.timeZone = TimeZone.current
            self.dateFormatter.locale = NSLocale.current
            self.dateFormatter.dateFormat = "EEE, MMM-dd"

            let date = Date(timeIntervalSince1970: timestamp)
            return self.dateFormatter.string(from: date)
        }
        
        func getDateStr(timestamp: Double) -> String {
            self.dateFormatter.timeZone = TimeZone.current
            self.dateFormatter.locale = NSLocale.current
            self.dateFormatter.dateFormat = "MMM-d, yyyy"
            
            let date = Date(timeIntervalSince1970: timestamp)
            return self.dateFormatter.string(from: date)
        }
    }
}
