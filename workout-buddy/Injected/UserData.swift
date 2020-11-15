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

extension AppState {
    class UserData {
        var isLoggedIn = false
        var didCreateAccount = false
        var workouts: [Workout] = []
        var exercises: [Exercise] = []
        var workoutLog: [CompletedWorkout] = []
        var trackingStatus: TrackingStatus
        var user: User
        var stats: Stats
        var weekEndTS: Double?
        var tenWeekRollingStats: TenWeekRollingStats
        
            
        private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? "" {
            didSet {
                UserDefaults.standard.set(self.userId, forKey: "userId")
            }
        }
        
        init() {
            self.trackingStatus = TrackingStatus()
            self.user = User()
            self.stats = Stats()
            self.tenWeekRollingStats = TenWeekRollingStats()
            self.weekEndTS = Date().endOfWeek()?.timeIntervalSince1970
            
            if userId != "" {
                self.isLoggedIn = true
                if let deviceId = UIDevice.current.identifierForVendor?.uuidString, deviceId == self.userId {
                    self.didCreateAccount = false
                } else {
                    self.didCreateAccount = true
                }
                
                self.loadAllData()
            }
        }
        
        func loadAllData() {
            if didCreateAccount { self.getUserData() }
            self.getWorkouts()
            self.getExercises()
            self.getWorkoutLogAndStats()
        }
        
        // TODO: - Listen for changes to save new workouts
        
        func saveNewUserWithoutAccount() {
            if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
                self.userId = deviceId
                self.isLoggedIn = true
                
                NetworkManager().saveNewUserWithoutAccount(id: self.userId)
                
                self.loadAllData()
            } else {
                // Do not proceed (Unable to start the trial at this time)
            }
        }
        
        func saveNewUser(email: String, pass: String) {
            
            let emailData = Data(email.utf8)
            let emailHash = SHA256.hash(data: emailData)
            let id = emailHash.compactMap {
                String(format: "%02x", $0)
            }.joined()
            
            if userId == "" {
                NetworkManager().saveNewUser(id: id, pass: pass, deviceId: nil)
            } else {
                NetworkManager().saveNewUser(id: id, pass: pass, deviceId: userId)
            }
            
            self.userId = id
            self.loadAllData()
            
            self.isLoggedIn = true
            self.didCreateAccount = true
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
                    self.didCreateAccount = success
                    if success {
                        self.userId = id
                        self.loadAllData()
                    }
                }
            }
        }
        
        func logOutUser() {
            if didCreateAccount {
                userId = ""
            }
            isLoggedIn = false
            didCreateAccount = false
            workouts = []
            exercises = []
            workoutLog = []
            user = User()
            stats = Stats()
            tenWeekRollingStats = TenWeekRollingStats()
        }
        
        func saveUserData(firstName: String?, lastName: String?, bio: String?, city: String?, state: String?, sport: String?, weight: String?, birthDate: Date?, sex: String?) {
            self.user.firstName = firstName
            self.user.lastName = lastName
            self.user.bio = bio
            self.user.city = city
            self.user.state = state
            self.user.sport = sport
            self.user.weight = weight != nil ? Double(weight ?? "0") : nil
            self.user.birthDate = birthDate
            self.user.sex = sex
            
            if self.user.profileImage != nil {
                self.user.profileImageUrl = "https://workout-server-public.s3.us-east-2.amazonaws.com/profile_photos/" + self.userId + ".jpeg"
            }
            
            let user = UserRequest(self.userId,
                            firstName: firstName,
                            lastName: lastName,
                            bio: bio,
                            city: city,
                            state: state,
                            sport: sport,
                            weight: weight != nil ? Double(weight ?? "0") : nil,
                            birthDate: birthDate,
                            sex: sex,
                            profileImageUrl: self.user.profileImageUrl
            )
            
            NetworkManager().saveUser(user: user)
        }
        
        func getUserData() {
            NetworkManager().getUser(id: self.userId) { (user) in
                self.user.firstName = user.firstName
                self.user.lastName = user.lastName
                self.user.bio = user.bio
                self.user.city = user.city
                self.user.state = user.state
                self.user.sport = user.sport
                self.user.weight = user.weight
                self.user.birthDate = user.birthDate
                self.user.sex = user.sex
                self.user.profileImageUrl = user.profileImageUrl
                
                if let profileImageUrl = self.user.profileImageUrl {
                    NetworkManager().getImage(from: profileImageUrl) { (image) in
                        self.user.profileImage = image
                    }
                }
            }
        }
        
        func updateUserImage() {
            
            guard let profileImage = self.user.profileImage else { return }
            
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
            
            self.stats.addStatsFrom(workout: completedWorkout)
            self.updateTenWeekRollingStats(with: completedWorkout)
            
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
                self.workoutLog.forEach { workout in
                    self.updateTenWeekRollingStats(with: workout)
                }
                
            }
        }
        
        func deleteWorkoutLogItem(completedWorkout: CompletedWorkout) {
            if let idx = self.workoutLog.firstIndex(of: completedWorkout) {
                
                self.workoutLog.remove(at: idx)
                NetworkManager().deleteWorkoutFromLog(userId: self.userId, wlId: completedWorkout.wlId)
                
                // Update stats
                self.stats.subtractStatsFrom(workout: completedWorkout)
                NetworkManager().saveStats(userId: self.userId, stats: self.stats)
                
                // Update weekly stats
                self.updateTenWeekRollingStats(with: completedWorkout, subtract: true)
            }
        }
        
        func updateTenWeekRollingStats(with workout: CompletedWorkout, subtract: Bool = false) {
            self.weekEndTS = Date().endOfWeek()?.timeIntervalSince1970
            let weekInS = 604800.0
            
            guard let weekEndTS = self.weekEndTS else { return }
            
            let weekIdx = 9 - Int(floor((weekEndTS - workout.startTS) / weekInS))
            if weekIdx > -1 && weekIdx < 10 {
                if subtract {
                    self.tenWeekRollingStats.weeklyStats[weekIdx].stats.subtractStatsFrom(workout: workout)
                } else {
                    self.tenWeekRollingStats.weeklyStats[weekIdx].stats.addStatsFrom(workout: workout)
                }
            }
        }
        
        func deleteWorkouts(at offsets: IndexSet) {
            var workoutIds: [String] = []
            offsets.forEach { i in
                workoutIds.append(workouts[i].id)
            }
            workouts.remove(atOffsets: offsets)
            NetworkManager().deleteWorkouts(userId: self.userId, workoutIds: workoutIds)
        }
    }
}


extension AppState.UserData {
    struct TrackingStatus {
        var started: Bool
        var new: Bool
        
        init() {
            self.started = false
            self.new = true
        }
    }
}


extension AppState.UserData {
    struct User {
        var firstName: String?
        var lastName: String?
        var bio: String?
        var city: String?
        var state: String?
        var sport: String?
        var weight: Double?
        var birthDate: Date?
        var sex: String?
        var profileImageUrl: String?
        var profileImage: UIImage?
    }
}
