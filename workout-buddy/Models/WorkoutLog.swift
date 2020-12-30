//
//  WorkoutLog.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-12-28.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct WorkoutLogItem: Codable {
    var wlId: String
    var workoutId: String
    var time: Int?
    var startTS: Double
    
    init(wlId: String, workoutId: String, time: Int?, startTS: Double) {
        self.wlId = wlId
        self.workoutId = workoutId
        self.time = time
        self.startTS = startTS
    }
}

struct ScheduledWorkout: Hashable, Codable {
    var scheduleId: String
    var workout: Workout
    var timestamp: Double
    
    init(workout: Workout, timestamp: Double) {
        self.scheduleId = UUID().uuidString
        self.workout = workout
        self.timestamp = timestamp
    }
}

struct WorkoutWeek: Hashable, Identifiable {
    var id: Int
    var completed: [CompletedWorkout]
    var scheduled: [ScheduledWorkout]
    
    init(id: Int) {
        self.id = id
        self.completed = []
        self.scheduled = []
    }
}


extension Array where Element == WorkoutWeek {
    mutating func addToLog(curWeek: Int, curWeekYear: Int, workout: CompletedWorkout, at weekIdx: Int) -> (Int, Int, Int) {
        let workoutWeekNum = Date(timeIntervalSince1970: workout.startTS).weekOfYear()
        if curWeek == workoutWeekNum {
            if !self.indices.contains(weekIdx) {
                var newWeek = WorkoutWeek(id: weekIdx)
                newWeek.completed = [workout]
                self.append(newWeek)
            } else {
                self[weekIdx].completed.append(workout)
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
