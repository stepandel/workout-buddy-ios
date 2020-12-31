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
    
    mutating func addStatsFrom(workout: WorkoutLogItem) {
        self.totalWorkoutsCompleted += 1
        if let time = workout.time {
            self.totalTimeWorkingout += time
        }
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
    
    mutating func subtractStatsFrom(workout: WorkoutLogItem) {
        self.totalWorkoutsCompleted -= 1
        if let time = workout.time {
            self.totalTimeWorkingout -= time
        }
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


struct ExerciseStats {
    var volume: Int
    var maxWeight: Int
    var totalReps: Int
    var maxReps: Int
    var totalSets: Int
    var totalTime: Int
    var maxTime: Int
    var oneRM: Int
    
    init() {
        self.volume = 0
        self.maxWeight = 0
        self.totalReps = 0
        self.maxReps = 0
        self.totalSets = 0
        self.totalTime = 0
        self.maxTime = 0
        self.oneRM = 0
    }
    
    mutating func addStatsFrom(sets: [ExSet]) {
        sets.forEach { set in
            // sets
            self.totalSets += 1
            
            // weight
            if let weight = set.weight, weight > 0 {
                self.volume += weight
                self.maxWeight = self.maxWeight > weight ? self.maxWeight : weight
            }
            
            // reps
            if let reps = set.reps, reps > 0 {
                self.totalReps += reps
                self.maxReps = self.maxReps > reps ? self.maxReps : reps
            }
            
            // time
            if let time = set.time, time > 0 {
                self.totalTime += time
                self.maxTime = self.maxTime > time ? self.maxTime : time
            }
        }
    }
}

func getExerciseStatsFromSets(exSets: [ExSet]) -> ExerciseStats {
    var exStats = ExerciseStats()
    var oneRM = 0.0
        
    exSets.forEach { set in
        // sets
        exStats.totalSets += 1
        
        // weight
        if let weight = set.weight, weight > 0 {
            exStats.volume += weight
            exStats.maxWeight = exStats.maxWeight > weight ? exStats.maxWeight : weight
        }
        
        // reps
        if let reps = set.reps, reps > 0 {
            exStats.totalReps += reps
            exStats.maxReps = exStats.maxReps > reps ? exStats.maxReps : reps
        }
        
        // time
        if let time = set.time, time > 0 {
            exStats.totalTime += time
            exStats.maxTime = exStats.maxTime > time ? exStats.maxTime : time
        }
        
        // oneRM
        if let weight = set.weight, let reps = set.reps, weight > 0, reps > 0 {
            let actualReps = reps > 10 ? 10 : reps
            let newOneRM = Double(weight) / (1.0278 - (0.0278*Double(actualReps)))
            oneRM = oneRM > newOneRM ? oneRM : newOneRM
        }
    }
    
    exStats.oneRM = Int(oneRM)
    
    return exStats
}

extension ExerciseStats {
    struct WeeklyStats {
        var id: Int
        var stats: ExerciseStats
        
        init(id: Int) {
            self.id = id
            self.stats = ExerciseStats()
        }
    }
    
    enum WeeklyStatsParameter {
        case volume
        case maxWeight
        case totalReps
        case maxReps
        case totalSets
        case totalTime
        case maxTime
        case oneRM
    }
}

struct TenWeekRollingExerciseStats {
    var weeklyStats: [ExerciseStats.WeeklyStats]
    
    init() {
        weeklyStats = []
        for i in 0...9 {
            let weeklyStats = ExerciseStats.WeeklyStats(id: i)
            self.weeklyStats.append(weeklyStats)
        }
    }
    
    func normilized(by param: ExerciseStats.WeeklyStatsParameter) -> [CGFloat] {
        return weeklyStats.map { week -> CGFloat in
            switch param {
            case .volume:
                return CGFloat(week.stats.volume)
            case .maxWeight:
                return CGFloat(week.stats.maxWeight)
            case .totalReps:
                return CGFloat(week.stats.totalReps)
            case .maxReps:
                return CGFloat(week.stats.maxReps)
            case .totalSets:
                return CGFloat(week.stats.totalSets)
            case .totalTime:
                return CGFloat(week.stats.totalTime)
            case .maxTime:
                return CGFloat(week.stats.maxTime)
            case .oneRM:
                return CGFloat(week.stats.oneRM)
            }
        }.normalized
    }
    
    func isAllZero(param: ExerciseStats.WeeklyStatsParameter) -> Bool {
        return weeklyStats.allSatisfy { weeklyStat -> Bool in
            switch param {
            case .volume:
                return weeklyStat.stats.volume == 0
            case .maxWeight:
                return weeklyStat.stats.maxWeight == 0
            case .totalReps:
                return weeklyStat.stats.totalReps == 0
            case .maxReps:
                return weeklyStat.stats.maxReps == 0
            case .totalSets:
                return weeklyStat.stats.totalSets == 0
            case .totalTime:
                return weeklyStat.stats.totalTime == 0
            case .maxTime:
                return weeklyStat.stats.maxTime == 0
            case .oneRM:
                return weeklyStat.stats.oneRM == 0
            }
        }
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
