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
        var completedWorkouts: [CompletedWorkout]
        
        init(appState: AppState) {
            self.appState = appState
            self.completedWorkouts = appState.userData.workoutLog
            self.workoutLog = []
            var curWeek = Date().weekOfYear()
            var curWeekYear = Date().yearForWeekOfYear()
            var weekIdx = 0
            self.completedWorkouts.reversed().forEach { workout in
                (curWeek, curWeekYear, weekIdx) = self.workoutLog.addToLog(curWeek: curWeek, curWeekYear: curWeekYear, workout: workout, at: weekIdx)
            }
            // For new users
            if self.workoutLog.isEmpty {
                self.workoutLog.append(WorkoutWeek(id: 0))
            }
        }
        
        func deleteWorkout(completedWorkout: CompletedWorkout, weekIdx: Int) {
            self.appState.deleteWorkoutLogItem(completedWorkout: completedWorkout)
            if let completedWorkoutsIdx = self.completedWorkouts.firstIndex(of: completedWorkout) {
                self.completedWorkouts.remove(at: completedWorkoutsIdx)
            }
            if let idxInWeek = self.workoutLog[weekIdx].completed.firstIndex(of: completedWorkout) {
                self.workoutLog[weekIdx].completed.remove(at: idxInWeek)
            }
        }
        
        func weekStr(weekIdx: Int) -> String {
            if weekIdx == 0 {
                return "This Week"
            }
            
            let today = Date()
            let weekDay = Calendar.gregorian.date(byAdding: .day, value: -weekIdx*7, to: today)
            
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
    }
}
