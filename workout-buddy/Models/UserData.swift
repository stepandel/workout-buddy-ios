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
import UIKit

struct TrackingStatus {
    var started: Bool
    var new: Bool
    
    init() {
        self.started = false
        self.new = true
    }
}

final class UserData: ObservableObject {
    @Published var isLoggedIn = false
    @Published var workouts: [Workout] = []
    @Published var exercises: [Exercise] = []
    @Published var workoutLog: [CompletedWorkout] = []
    @Published var trackingStatus: TrackingStatus
    @Published var selectedTab: Int
    @Published var firstName: String?
    @Published var lastName: String?
    @Published var bio: String?
    @Published var city: String?
    @Published var state: String?
    @Published var sport: String?
    @Published var weight: Double?
    @Published var birthDate: Date?
    @Published var sex: String?
    @Published var profileImageUrl: String?
    @Published var profileImage: UIImage?
    @Published var stats: Stats
    @Published var weekEndTS: Double?
    @Published var tenWeekRollingStats: TenWeekRollingStats
    
        
    private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? "" {
        didSet {
            UserDefaults.standard.set(self.userId, forKey: "userId")
        }
    }
    
    init() {
        self.trackingStatus = TrackingStatus()
        self.selectedTab = 0
        self.stats = Stats()
        self.tenWeekRollingStats = TenWeekRollingStats()
        self.weekEndTS = Date().endOfWeek()?.timeIntervalSince1970
        
        if userId != "" {
            self.isLoggedIn = true
            
            self.loadAllData()
        }
    }
    
    func loadAllData() {
        self.getUserData()
        self.getWorkouts()
        self.getExercises()
        self.getWorkoutLogAndStats()
    }
    
    // TODO: - Listen for changes to save new workouts
    
    func saveNewUser(email: String, pass: String) {
        
        let emailData = Data(email.utf8)
        let emailHash = SHA256.hash(data: emailData)
        let id = emailHash.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        NetworkManager().saveNewUser(id: id, pass: pass)
        
        self.userId = id
        
        self.isLoggedIn = true
    }
    
    func checkUser(email: String, pass: String) {
        
        let emailData = Data(email.utf8)
        let emailHash = SHA256.hash(data: emailData)
        let id = emailHash.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        NetworkManager().checkUser(id: id, pass: pass) { (success) in
            DispatchQueue.main.async {
                self.isLoggedIn = success
                if success {
                    self.userId = id
                    self.loadAllData()
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
        firstName = nil
        lastName = nil
        bio = nil
        city = nil
        state = nil
        sport = nil
        weight = nil
        birthDate = nil
        sex = nil
        profileImage = nil
        profileImageUrl = nil
        stats = Stats()
        tenWeekRollingStats = TenWeekRollingStats()
    }
    
    func saveUserData(firstName: String?, lastName: String?, bio: String?, city: String?, state: String?, sport: String?, weight: String?, birthDate: Date?, sex: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.city = city
        self.state = state
        self.sport = sport
        self.weight = weight != nil ? Double(weight ?? "0") : nil
        self.birthDate = birthDate
        self.sex = sex
        
        if self.profileImage != nil {
            self.profileImageUrl = "https://workout-server-public.s3.us-east-2.amazonaws.com/profile_photos/" + self.userId + ".jpeg"
        }
        
        let user = User(self.userId,
                        firstName: firstName,
                        lastName: lastName,
                        bio: bio,
                        city: city,
                        state: state,
                        sport: sport,
                        weight: weight != nil ? Double(weight ?? "0") : nil,
                        birthDate: birthDate,
                        sex: sex,
                        profileImageUrl: self.profileImageUrl
        )
        
        NetworkManager().saveUser(user: user)
    }
    
    func getUserData() {
        NetworkManager().getUser(id: self.userId) { (user) in
            self.firstName = user.firstName
            self.lastName = user.lastName
            self.bio = user.bio
            self.city = user.city
            self.state = user.state
            self.sport = user.sport
            self.weight = user.weight
            self.birthDate = user.birthDate
            self.sex = user.sex
            self.profileImageUrl = user.profileImageUrl
            
            if let profileImageUrl = self.profileImageUrl {
                NetworkManager().getImage(from: profileImageUrl) { (image) in
                    self.profileImage = image
                }
            }
        }
    }
    
    func updateUserImage() {
        
        guard let profileImage = profileImage else { return }
        
        let imageData = profileImage.jpeg(.low)
        let imageAsString = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        guard let imageStr = imageAsString else { return }
        
        NetworkManager().uploadUserImage(userId: self.userId, userImage: imageStr)
    }
    
    func getWorkouts() {
        NetworkManager().getWorkouts(userId: self.userId) { (workouts) in
            self.workouts = workouts
        }
    }
    
    func getExercises() {
        NetworkManager().getExercises(userId: self.userId) { (exercises) in
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
        workoutLog.append(completedWorkout)
        
        // Update existing workout or create new one
        if let index = workouts.firstIndex(where: { $0.id == completedWorkout.workout.id }) {
            
            let originalWorkout = workouts[index]
            
            if isSameWorkout(w1: originalWorkout, w2: completedWorkout.workout) {
                NetworkManager().saveWorkout(workout: completedWorkout.workout, userId: self.userId)
            } else {
                let newWorkout = Workout(workout: completedWorkout.workout)
                NetworkManager().saveWorkout(workout: newWorkout, userId: self.userId)
                workouts.append(newWorkout)
            }
            
        } else {
            NetworkManager().saveWorkout(workout: completedWorkout.workout, userId: self.userId)
            workouts.append(completedWorkout.workout)
        }
        
        // Update stats
        let curTS = Date().timeIntervalSince1970
        if let weekEndTS = self.weekEndTS, weekEndTS < curTS {
            self.weekEndTS = Date().endOfWeek()?.timeIntervalSince1970
            self.tenWeekRollingStats = TenWeekRollingStats()
        }
        
        self.stats.totalWorkoutsCompleted += 1
        self.tenWeekRollingStats.stats[9].workoutsCompleted += 1
        self.stats.totalTimeWorkingout += completedWorkout.time
        self.tenWeekRollingStats.stats[9].timeWorkingout += completedWorkout.time
        completedWorkout.workout.rounds.forEach { round in
            round.sets.forEach { sets in
                sets.forEach { set in
                    self.stats.totalSetsCompleted += 1
                    self.tenWeekRollingStats.stats[9].setsCompleted += 1
                    if let reps = set.reps, reps > 0 {
                        self.stats.totalRepsCompleted += reps
                        self.tenWeekRollingStats.stats[9].repsCompleted += reps
                    }
                    if let weight = set.weight, weight > 0 {
                        self.stats.totalWeightLifted += weight
                        self.tenWeekRollingStats.stats[9].weightLifted += weight
                    }
                }
            }
        }
        
        NetworkManager().saveStats(userId: self.userId, stats: self.stats)
    }
    
    func saveExercise(exercise: Exercise) {
        NetworkManager().saveExercise(exercise: exercise, userId: self.userId)
    }
    
    func getStats() {
        NetworkManager().getStats(userId: self.userId) { stats in
            self.stats = stats
        }
    }
    
    func getWorkoutLogAndStats() {
        let timezoneOffset = TimeZone.current.secondsFromGMT() / 60
        NetworkManager().getCompletedWorkoutsAndStatsForUser(userId: self.userId, timezoneOffset: timezoneOffset) { (workoutLog, stats) in
            self.workoutLog = workoutLog
            self.stats = stats
            
            // Calculate 10 Week rolling stats
            self.weekEndTS = Date().endOfWeek()?.timeIntervalSince1970
            let weekInS = 604800.0
            
            self.workoutLog.forEach { workout in
                guard let weekEndTS = self.weekEndTS else { return }
                let weekIdx = 9 - Int(floor((weekEndTS - workout.startTS) / weekInS))
                if weekIdx > -1 && weekIdx < 10 {
                
                    self.tenWeekRollingStats.stats[weekIdx].workoutsCompleted += 1
                    self.tenWeekRollingStats.stats[weekIdx].timeWorkingout += workout.time
                    workout.workout.rounds.forEach { round in
                        round.sets.forEach { sets in
                            sets.forEach { set in
                                self.tenWeekRollingStats.stats[weekIdx].setsCompleted += 1
                                if let reps = set.reps, reps > 0 {
                                    self.tenWeekRollingStats.stats[weekIdx].repsCompleted += reps
                                }
                                if let weight = set.weight, weight > 0 {
                                    self.tenWeekRollingStats.stats[weekIdx].weightLifted += weight
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    func deleteWorkoutLogItem(completedWorkout: CompletedWorkout) {
        NetworkManager().deleteWorkoutFromLog(userId: self.userId, wlId: completedWorkout.wlId)
        
        if let idx = self.workoutLog.firstIndex(of: completedWorkout) {
            self.workoutLog.remove(at: idx)
        }
    }
}
