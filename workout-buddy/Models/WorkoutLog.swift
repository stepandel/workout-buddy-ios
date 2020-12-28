//
//  WorkoutLog.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-12-28.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct WorkoutWeek: Hashable, Identifiable {
    var id: Int
    var workouts: [CompletedWorkout]
    
    init(id: Int) {
        self.id = id
        self.workouts = []
    }
}


extension Array where Element == WorkoutWeek {
    mutating func addToLog(curWeek: Int, curWeekYear: Int, workout: CompletedWorkout, at weekIdx: Int) -> (Int, Int, Int) {
        let workoutWeekNum = Date(timeIntervalSince1970: workout.startTS).weekOfYear()
        if curWeek == workoutWeekNum {
            if !self.indices.contains(weekIdx) {
                var newWeek = WorkoutWeek(id: weekIdx)
                newWeek.workouts = [workout]
                self.append(newWeek)
            } else {
                self[weekIdx].workouts.append(workout)
            }
            
            return (curWeek, curWeekYear, weekIdx)
            
        } else {
            if !self.indices.contains(weekIdx) {
                self.append(WorkoutWeek(id: weekIdx))
            }
            if curWeek == 1 {
                let prevWeekYear = curWeekYear - 1
                if let prevWeek = Date().lastWeekOfYear(for: prevWeekYear) {
                    return self.addToLog(curWeek: prevWeek, curWeekYear: prevWeekYear, workout: workout, at: weekIdx + 1)
                } else {
                    return (curWeek, curWeekYear, weekIdx)
                }
            } else {
                let prevWeek = curWeek - 1
                return self.addToLog(curWeek: prevWeek, curWeekYear: curWeekYear, workout: workout, at: weekIdx + 1)
            }
            
        }
    }
}
