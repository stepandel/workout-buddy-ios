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
}

enum WeeklyStatsParameter {
    case workoutsCompleted
    case weightLifted
    case repsCompleted
    case setsCompleted
    case timeWorkoingout
}

struct TenWeekRollingStats: Hashable, Codable {
    var stats: [WeeklyStats]
    
    init() {
        self.stats = []
        for i in 0...9 {
            let weeklyStats = WeeklyStats(id: i)
            self.stats.append(weeklyStats)
        }
    }
    
    func normilized(by param: WeeklyStatsParameter) -> [CGFloat] {
        return stats.map { stat -> CGFloat in
            switch param {
            case .workoutsCompleted:
                return CGFloat(stat.workoutsCompleted)
            case .weightLifted:
                return CGFloat(stat.weightLifted)
            case .repsCompleted:
                return CGFloat(stat.repsCompleted)
            case .setsCompleted:
                return CGFloat(stat.setsCompleted)
            case .timeWorkoingout:
                return CGFloat(stat.timeWorkingout)
            }
        }.normalized
    }
}

struct WeeklyStats: Hashable, Codable, Identifiable {
    var id: Int
    var workoutsCompleted: Int
    var weightLifted: Int
    var repsCompleted: Int
    var setsCompleted: Int
    var timeWorkingout: Int
    
    init(id: Int) {
        self.id = id
        self.workoutsCompleted = 0
        self.weightLifted = 0
        self.repsCompleted = 0
        self.setsCompleted = 0
        self.timeWorkingout = 0
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
