//
//  WorkoutLog.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-12-28.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct WorkoutLogItem: Hashable, Codable {
    var wlId: String
    var workout: Workout
    var time: Int?
    var startTS: Double
    
    init(workout: Workout, startTS: Double, time: Int) {
        self.wlId = UUID().uuidString
        self.workout = workout
        self.startTS = startTS
        self.time = time
    }
    
    func stringFormattedTime() -> String {
        if let time = self.time {
            let hours = String(time / 3600)
            let minutes = String(format: "%02d", (time % 3600) / 60 )
            let seconds = String(format: "%02d", (time % 3600) % 60 )
            
            return hours + ":" + minutes + ":" + seconds
        } else {
            return ""
        }
    }
    
    func getWorkoutStats() -> WorkoutStats {
        var workoutStats = WorkoutStats()
        self.workout.rounds.forEach { round in
            round.sets.forEach { sets in
                sets.forEach { set in
                    workoutStats.setsCompleted += 1
                    if !workoutStats.completedExercises.contains(set.exId) {
                        workoutStats.completedExercises.append(set.exId)
                    }
                    if let reps = set.reps, reps > 0 {
                        workoutStats.repsCompleted += reps
                    }
                    if let weight = set.weight, weight > 0 {
                        workoutStats.weightLifted += weight
                    }
                }
            }
        }
        return workoutStats
    }
}

struct WorkoutWeek: Hashable, Identifiable {
    var id: Int
    var completed: [WorkoutLogItem]
    var scheduled: [WorkoutLogItem]
    
    init(id: Int) {
        self.id = id
        self.completed = []
        self.scheduled = []
    }
}


extension Array where Element == WorkoutWeek {
    mutating func addToLog(curWeek: Int, curWeekYear: Int, workout: WorkoutLogItem, at weekIdx: Int) -> (Int, Int, Int) {
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
