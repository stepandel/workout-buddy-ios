//
//  UserData.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-13.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var exercises: [Exercise] = []
    @Published var workoutLog: [CompletedWorkout] = []
    private var userId: String = UIDevice.current.identifierForVendor?.uuidString ?? "fake666"
    
    init() {
        getWorkouts()
        getExercises()
        getWorkoutLog()
    }
    
    // TODO: - Listen for changes to save new workouts
    
    func getWorkouts() {
        NetworkManager().getWorkouts(userId: self.userId) { (workouts) in
            self.workouts = workouts
        }
    }
    
    func getExercises() {
        NetworkManager().getExercises(userId: self.userId) { (exercises) in
            print("\(exercises)")
            self.exercises = exercises
        }
    }
    
    func getWorkoutLog() {
        NetworkManager().getWorkoutLog(userId: self.userId) { (completedWorkouts) in
            self.workoutLog = completedWorkouts
        }
    }
    
    func saveWorkout(workout: Workout) {
        NetworkManager().saveWorkout(workout: workout, userId: self.userId)
    }
    
    func saveCompletedWorkout(completedWorkout: CompletedWorkout) {
        NetworkManager().saveCompletedWorkout(completedWorkout: completedWorkout, userId: self.userId)
    }
    
    func saveExercise(exercise: Exercise) {
        NetworkManager().saveExercise(exercise: exercise, userId: self.userId)
    }
}
