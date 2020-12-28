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
    var startTS: Double
    var time: Int
    
    init(workout: Workout, startTS: Double, time: Int) {
        self.wlId = UUID().uuidString
        self.workout = workout
        self.startTS = startTS
        self.time = time
    }
    
    func stringFormattedTime() -> String {
        let hours = String(self.time / 3600)
        let minutes = String(format: "%02d", (self.time % 3600) / 60 )
        let seconds = String(format: "%02d", (self.time % 3600) % 60 )
        
        return hours + ":" + minutes + ":" + seconds
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

struct CompletedWorkoutShort: Codable {
    var wlId: String
    var workoutId: String
    var time: Int
    var startTS: Double
    
    init(wlId: String, workoutId: String, time: Int, startTS: Double) {
        self.wlId = wlId
        self.workoutId = workoutId
        self.time = time
        self.startTS = startTS
    }
}
