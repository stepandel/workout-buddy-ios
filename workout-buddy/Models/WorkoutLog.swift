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
    var placeholder: Bool?
    
    init(workout: Workout, startTS: Double, time: Int?, placeholder: Bool? = nil) {
        self.wlId = UUID().uuidString
        self.workout = workout
        self.startTS = startTS
        self.time = time
        self.placeholder = placeholder
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
    var items: [[WorkoutLogItem]]
    
    init(id: Int) {
        self.id = id
        self.items = []
    }
}

extension WorkoutWeek {
    struct PlaceholderItem: Hashable, Identifiable {
        var id: String
        var title: String
        var date: Date
        
        init(title: String, date: Date) {
            self.id = UUID().uuidString
            self.title = title
            self.date = date
        }
    }
}


extension Array where Element == WorkoutWeek {
    mutating func addToLog(curWeek: Int, curWeekYear: Int, workout: WorkoutLogItem, at weekIdx: Int) -> (Int, Int, Int) {
        let workoutWeekNum = Date(timeIntervalSince1970: workout.startTS).weekOfYear()
        if curWeek == workoutWeekNum {
            if !self.indices.contains(weekIdx) {
                var newWeek = WorkoutWeek(id: weekIdx)
                newWeek.items = [[workout]]
                self.append(newWeek)
            } else {
                
                // check if prev workout is in the same day
                self[weekIdx].items.indices.last.map{ i in
                    let lastWorkoutDay = Date(timeIntervalSince1970: self[weekIdx].items[i][0].startTS).dayOfMonth()
                    let thisWorkoutDay = Date(timeIntervalSince1970: workout.startTS).dayOfMonth()
                    
                    if lastWorkoutDay == thisWorkoutDay {
                        self[weekIdx].items[i].append(workout)
                    } else {
                        self[weekIdx].items.append([workout])
                    }
                }
            }
            
            return (curWeek, curWeekYear, weekIdx)
            
        } else {
            if !self.indices.contains(weekIdx) {
                self.append(WorkoutWeek(id: weekIdx))
            }
            
            if weekIdx == 0 || weekIdx == 1 {
                var lastWorkoutDay = 1
                let today = Date().dayOfWeek()
                if let lastWorkoutDayIdx = self[weekIdx].items.indices.last {
                    lastWorkoutDay = Date(timeIntervalSince1970: self[weekIdx].items[lastWorkoutDayIdx][0].startTS).dayOfWeek()
                }
                if weekIdx == 1 {
                    lastWorkoutDay = lastWorkoutDay < today ? today - 1 : lastWorkoutDay
                }
                if lastWorkoutDay < 8 {
                    let daysToFill = (lastWorkoutDay + 1)...8
                    
                    for i in daysToFill.reversed() {
                        if let placeholderDate = Date().dateFrom(weekday: i, weekOfYear: curWeek, yearForWeekOfYear: curWeekYear) {
                            let placeholder = WorkoutLogItem(workout: Workout(), startTS: placeholderDate.timeIntervalSince1970, time: nil, placeholder: true)
                            self[weekIdx].items.append([placeholder])
                        }
                    }
                }
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
