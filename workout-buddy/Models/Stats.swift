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
