//
//  UserData.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-13.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import Combine
import SwiftUI
import CryptoKit

final class UserData: ObservableObject {
    @Published var isLoggedIn = false
    @Published var workouts: [Workout] = []
    @Published var exercises: [Exercise] = []
    @Published var workoutLog: [CompletedWorkout] = []
    private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? "" {
        didSet {
            UserDefaults.standard.set(self.userId, forKey: "userId")
        }
    }
    
    init() {
        if userId != "" {
            isLoggedIn = true
        }
    }
    
    // TODO: - Listen for changes to save new workouts
    
    func saveNewUser(email: String, pass: String) {
        
        let emailData = Data(email.utf8)
        let id = SHA256.hash(data: emailData).description
        
        NetworkManager().saveNewUser(id: id, pass: pass)
        
        self.userId = id
        
        self.isLoggedIn = true
    }
    
    func checkUser(email: String, pass: String) {
        
        let emailData = Data(email.utf8)
        let id = SHA256.hash(data: emailData).description
        
        NetworkManager().checkUser(id: id, pass: pass) { (success) in
            DispatchQueue.main.async {
                self.isLoggedIn = success
                
                print("\n \n Success loggin in? \(String(success)) \n \n")
                
                if success {
                    
                    self.userId = id
                    
                    self.getWorkouts()
                    self.getExercises()
                    self.getWorkoutLog()
                }
            }
        }
    }
    
    func logOutUser() {
        userId = ""
        isLoggedIn = false
        workouts = []
        exercises = []
        workoutLog = []
    }
    
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
