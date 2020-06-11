//
//  CompletedWorkout.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-12.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct CompletedWorkout: Hashable, Codable {
    var wlId: String
    var workout: Workout
    var completionTs: Double
    var time: Int
    
    init(workout: Workout, completionTs: Double, time: Int) {
        self.wlId = UUID().uuidString
        self.workout = workout
        self.completionTs = completionTs
        self.time = time
    }
}

struct CompletedWorkoutShort: Codable {
    var wlId: String
    var workoutId: String
    var time: Int
    var completionTs: Double
    
    init(wlId: String, workoutId: String, time: Int, completionTs: Double) {
        self.wlId = wlId
        self.workoutId = workoutId
        self.time = time
        self.completionTs = completionTs
    }
}
