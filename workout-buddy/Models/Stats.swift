//
//  Stats.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-10-08.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct Stats: Hashable, Codable {
    var totalWorkoutsCompleted: Int
    var totalWeightLifted: Int
    var totalRepsCompleted: Int
    var totalSetsCompleted: Int
    var totalTimeWorkingout: Int
    
    init() {
        self.totalWorkoutsCompleted = 0
        self.totalWeightLifted = 0
        self.totalRepsCompleted = 0
        self.totalSetsCompleted = 0
        self.totalTimeWorkingout = 0
    }
    
    mutating func addStatsFrom(workout: CompletedWorkout) {
        self.totalWorkoutsCompleted += 1
        self.totalTimeWorkingout += workout.time
        workout.workout.rounds.forEach { round in
            round.sets.forEach { sets in
                sets.forEach { set in
                    self.totalSetsCompleted += 1
                    if let reps = set.reps, reps > 0 {
                        self.totalRepsCompleted += reps
                    }
                    if let weight = set.weight, weight > 0 {
                        self.totalWeightLifted += weight
                    }
                }
            }
        }
    }
    
    mutating func subtractStatsFrom(workout: CompletedWorkout) {
        self.totalWorkoutsCompleted -= 1
        self.totalTimeWorkingout -= workout.time
        workout.workout.rounds.forEach { round in
            round.sets.forEach { sets in
                sets.forEach { set in
                    self.totalSetsCompleted -= 1
                    if let reps = set.reps, reps > 0 {
                        self.totalRepsCompleted -= reps
                    }
                    if let weight = set.weight, weight > 0 {
                        self.totalWeightLifted -= weight
                    }
                }
            }
        }
    }
}

enum WeeklyStatsParameter {
    case workoutsCompleted
    case weightLifted
    case repsCompleted
    case setsCompleted
    case timeWorkoingout
}

struct TenWeekRollingStats: Hashable, Codable {
    var weeklyStats: [WeeklyStats]
    
    init() {
        self.weeklyStats = []
        for i in 0...9 {
            let weeklyStats = WeeklyStats(id: i)
            self.weeklyStats.append(weeklyStats)
        }
    }
    
    func normilized(by param: WeeklyStatsParameter) -> [CGFloat] {
        return weeklyStats.map { week -> CGFloat in
            switch param {
            case .workoutsCompleted:
                return CGFloat(week.stats.totalWorkoutsCompleted)
            case .weightLifted:
                return CGFloat(week.stats.totalWeightLifted)
            case .repsCompleted:
                return CGFloat(week.stats.totalRepsCompleted)
            case .setsCompleted:
                return CGFloat(week.stats.totalSetsCompleted)
            case .timeWorkoingout:
                return CGFloat(week.stats.totalTimeWorkingout)
            }
        }.normalized
    }
}

struct WeeklyStats: Hashable, Codable, Identifiable {
    var id: Int
    var stats: Stats
    
    init(id: Int) {
        self.id = id
        self.stats = Stats()
    }
}

struct WorkoutStats {
    var completedExercises: [String]
    var repsCompleted: Int
    var setsCompleted: Int
    var weightLifted: Int
    
    init() {
        self.completedExercises = []
        self.repsCompleted = 0
        self.setsCompleted = 0
        self.weightLifted = 0
    }
}

extension Array where Element == CGFloat {
    var normalized: [CGFloat] {
        if let _ = self.min(), let max = self.max() {
            let max = max > 0 ? max : 1 // To avoid infinite results
            return self.map { ($0 + (max * 0.05))  / (max * 1.2) }
        }
        return []
    }
}
