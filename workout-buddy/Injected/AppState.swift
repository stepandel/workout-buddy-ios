//
//  AppState.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-13.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI
import Combine
import CryptoKit

final class AppState: ObservableObject {
    @Published var userData = UserData()
    @Published var routing = ViewRouting()
    @Published var trackingData = TrackingData()
    
    let networkManger = NetworkManager()
    
    init() {
        self.loadAllData()
    }
}

extension AppState {
    struct ViewRouting {
        var contentView = ContentView.Routing()
        var trackWorkout = TrackWorkout.Routing()
        var editWorkout = EditWorkout.Routing()
        var exrecises = Exercises.Routing()
    }
}

extension AppState {
    struct TrackingData {
        var workout = Workout()
        var workoutStarted = false
        var startTime: Double = 0
        var currentRound = 0
        var addExAfterIdx = 0
        var curExIdx = 0
        
        mutating func reset() {
            self.workout = Workout()
            self.workoutStarted = false
            self.startTime = 0
            self.currentRound = 0
            self.addExAfterIdx = 0
            self.curExIdx = 0
        }
    }
}


// MARK: - UserData Manager

extension AppState {
    
    func loadAllData() {
        if self.userData.didCreateAccount { self.getUserData() }
        self.getWorkouts()
        self.getExercises()
        self.getWorkoutLogAndStats()
    }
    
    
    // MARK: - User
    
    func saveNewUser(email: String, pass: String) {
        
        let emailData = Data(email.utf8)
        let emailHash = SHA256.hash(data: emailData)
        let id = emailHash.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        if self.userData.userId == "" {
            self.networkManger.saveNewUser(id: id, pass: pass, deviceId: nil)
        } else {
            self.networkManger.saveNewUser(id: id, pass: pass, deviceId: self.userData.userId)
        }
        
        self.userData.userId = id
        self.loadAllData()
        
        self.userData.isLoggedIn = true
        self.userData.didCreateAccount = true
    }
    
    func checkUser(email: String, pass: String) {
        
        let emailData = Data(email.utf8)
        let emailHash = SHA256.hash(data: emailData)
        let id = emailHash.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        self.networkManger.checkUser(id: id, pass: pass) { (success) in
            DispatchQueue.main.async {
                self.userData.isLoggedIn = success
                self.userData.didCreateAccount = success
                if success {
                    self.userData.userId = id
                    self.loadAllData()
                }
            }
        }
    }
    
    func logOutUser() {
        if self.userData.didCreateAccount {
            self.userData.userId = ""
        }
        self.userData.isLoggedIn = false
        self.userData.didCreateAccount = false
        self.userData.workouts = []
        self.userData.exercises = []
        self.userData.workoutLog = []
        self.userData.user = User()
        self.userData.stats = Stats()
        self.userData.tenWeekRollingStats = TenWeekRollingStats()
    }
    
    func saveUserData(firstName: String?, lastName: String?, bio: String?, city: String?, state: String?, sport: String?, weight: String?, birthDate: Date?, sex: String?) {
        self.userData.user.firstName = firstName
        self.userData.user.lastName = lastName
        self.userData.user.bio = bio
        self.userData.user.city = city
        self.userData.user.state = state
        self.userData.user.sport = sport
        self.userData.user.weight = weight != nil ? Double(weight ?? "0") : nil
        self.userData.user.birthDate = birthDate
        self.userData.user.sex = sex
        
        if self.userData.user.profileImage != nil {
            self.userData.user.profileImageUrl = "https://workout-server-public.s3.us-east-2.amazonaws.com/profile_photos/" + self.userData.userId + ".jpeg"
        }
        
        let user = UserRequest(self.userData.userId,
                        firstName: firstName,
                        lastName: lastName,
                        bio: bio,
                        city: city,
                        state: state,
                        sport: sport,
                        weight: weight != nil ? Double(weight ?? "0") : nil,
                        birthDate: birthDate,
                        sex: sex,
                        profileImageUrl: self.userData.user.profileImageUrl
        )
        
        self.networkManger.saveUser(user: user)
    }
    
    func updateUserImage() {
        
        guard let profileImage = self.userData.user.profileImage else { return }
        
        let imageData = profileImage.jpeg(.low)
        let imageAsString = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        guard let imageStr = imageAsString else { return }
        
        self.networkManger.uploadUserImage(userId: self.userData.userId, userImage: imageStr)
    }
    
    func getUserData() {
        self.networkManger.getUser(id: self.userData.userId) { (user) in
            self.userData.user.firstName = user.firstName
            self.userData.user.lastName = user.lastName
            self.userData.user.bio = user.bio
            self.userData.user.city = user.city
            self.userData.user.state = user.state
            self.userData.user.sport = user.sport
            self.userData.user.weight = user.weight
            self.userData.user.birthDate = user.birthDate
            self.userData.user.sex = user.sex
            self.userData.user.profileImageUrl = user.profileImageUrl

            if let profileImageUrl = self.userData.user.profileImageUrl {
                self.networkManger.getImage(from: profileImageUrl) { (image) in
                    self.userData.user.profileImage = image
                }
            }
        }
    }
    
    func saveNewUserWithoutAccount() {
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            self.userData.userId = deviceId
            self.userData.isLoggedIn = true
            
            self.networkManger.saveNewUserWithoutAccount(id: self.userData.userId)
            
            self.loadAllData()
        } else {
            // Do not proceed (Unable to start the trial at this time)
        }
    }
    
    
    // MARK: - Exercises

    func getExercises() {
        self.networkManger.getExercises(userId: self.userData.userId) { (exercises) in
            self.userData.exercises = exercises
            self.userData.allExercises.append(contentsOf: exercises)
            self.userData.allExercises.sort()
            self.userData.allExercises.removeDuplicates()
        }
    }
    
    func saveExercise(exercise: Exercise) {
        self.networkManger.saveExercise(exercise: exercise, userId: self.userData.userId)
        self.userData.exercises.append(exercise)
        self.userData.allExercises.append(exercise)
    }
    
    
    // MARK: - Workouts
    
    func getWorkouts() {
        self.networkManger.getWorkouts(userId: self.userData.userId) { (workouts) in
            self.userData.workouts = workouts
        }
    }
    
    func getWorkoutLog() {
        self.networkManger.getWorkoutLog(userId: self.userData.userId) { (completedWorkouts) in
            self.userData.workoutLog = completedWorkouts
        }
    }
    
    func saveWorkout(workout: Workout) {
        self.networkManger.saveWorkout(workout: workout, userId: self.userData.userId)
    }
    
    func saveCompletedWorkout(completedWorkout: CompletedWorkout) {
        self.networkManger.saveCompletedWorkout(completedWorkout: completedWorkout, userId: self.userData.userId)
        self.userData.workoutLog.append(completedWorkout)
        
        // Update existing workout or create new one
        if let index = self.userData.workouts.firstIndex(where: { $0.id == completedWorkout.workout.id }) {
            
            let originalWorkout = self.userData.workouts[index]
            
            if isSameWorkout(w1: originalWorkout, w2: completedWorkout.workout) {
                self.networkManger.saveWorkout(workout: completedWorkout.workout, userId: self.userData.userId)
            } else {
                let newWorkout = Workout(workout: completedWorkout.workout)
                self.networkManger.saveWorkout(workout: newWorkout, userId: self.userData.userId)
                self.userData.workouts.append(newWorkout)
            }
            
        } else {
            self.networkManger.saveWorkout(workout: completedWorkout.workout, userId: self.userData.userId)
            self.userData.workouts.append(completedWorkout.workout)
        }
        
        // Update stats
        let curTS = Date().timeIntervalSince1970
        if let weekEndTS = self.userData.weekEndTS, weekEndTS < curTS {
            self.userData.weekEndTS = Date().endOfWeek()?.timeIntervalSince1970
            self.userData.tenWeekRollingStats = TenWeekRollingStats()
        }
        
        self.userData.stats.addStatsFrom(workout: completedWorkout)
        self.updateTenWeekRollingStats(with: completedWorkout)
        self.recalculateExerciseStats()
        
        self.networkManger.saveStats(userId: self.userData.userId, stats: self.userData.stats)
    }
    
    func getStats() {
        self.networkManger.getStats(userId: self.userData.userId) { stats in
            self.userData.stats = stats
        }
    }
    
    func deleteWorkoutLogItem(completedWorkout: CompletedWorkout) {
        if let idx = self.userData.workoutLog.firstIndex(of: completedWorkout) {
            
            self.userData.workoutLog.remove(at: idx)
            self.networkManger.deleteWorkoutFromLog(userId: self.userData.userId, wlId: completedWorkout.wlId)
            
            // Update stats
            self.userData.stats.subtractStatsFrom(workout: completedWorkout)
            self.networkManger.saveStats(userId: self.userData.userId, stats: self.userData.stats)
            
            // Update weekly stats
            self.updateTenWeekRollingStats(with: completedWorkout, subtract: true)
            self.recalculateExerciseStats()
        }
    }
    
    func getWorkoutLogAndStats() {
        let timezoneOffset = TimeZone.current.secondsFromGMT() / 60
        self.networkManger.getCompletedWorkoutsAndStatsForUser(userId: self.userData.userId, timezoneOffset: timezoneOffset) { (workoutLog, stats) in
            self.userData.workoutLog = workoutLog
            self.userData.stats = stats
            self.userData.workoutLog.forEach { workout in
                self.updateTenWeekRollingStats(with: workout)
            }
            
            self.recalculateExerciseStats()
        }
    }
    
    func deleteWorkouts(at offsets: IndexSet) {
        var workoutIds: [String] = []
        offsets.forEach { i in
            workoutIds.append(self.userData.workouts[i].id)
        }
        self.userData.workouts.remove(atOffsets: offsets)
        self.networkManger.deleteWorkouts(userId: self.userData.userId, workoutIds: workoutIds)
    }
    
    
    // MARK: - Stats
    
    func updateTenWeekRollingStats(with workout: CompletedWorkout, subtract: Bool = false) {
        self.userData.weekEndTS = Date().endOfWeek()?.timeIntervalSince1970
        let weekInS = 604800.0
        
        guard let weekEndTS = self.userData.weekEndTS else { return }
        
        let weekIdx = 9 - Int(floor((weekEndTS - workout.startTS) / weekInS))
        if weekIdx > -1 && weekIdx < 10 {
            if subtract {
                self.userData.tenWeekRollingStats.weeklyStats[weekIdx].stats.subtractStatsFrom(workout: workout)
            } else {
                self.userData.tenWeekRollingStats.weeklyStats[weekIdx].stats.addStatsFrom(workout: workout)
            }
        }
    }
    
    func recalculateExerciseStats() {
        self.userData.workoutLog.forEach { completedWorkout in
            completedWorkout.workout.rounds.forEach { round in
                
                var oneRMs: [String: Double] = [:]
                
                round.sets.forEach { sets in
                    if self.userData.exerciseData[sets[0].exId] == nil {
                        self.userData.exerciseData[sets[0].exId] = ExerciseStats()
                    }
                    self.userData.exerciseData[sets[0].exId]?.addStatsFrom(sets: sets)
                    
                    // oneRM
                    sets.forEach { set in
                        if let weight = set.weight, let reps = set.reps, weight > 0, reps > 0 {
                            if oneRMs[set.exId] == nil {
                                oneRMs[set.exId] = 0.0
                            }
                            let actualReps = reps > 10 ? 10 : reps
                            let newOneRM = Double(weight) / (1.0278 - (0.0278*Double(actualReps)))
                            oneRMs[set.exId] = oneRMs[set.exId]! > newOneRM ? oneRMs[set.exId] : newOneRM
                        }
                    }
                }
                
                for (exId, oneRM) in oneRMs {
                    self.userData.exerciseData[exId]?.oneRM = Int(oneRM)
                }
            }
        }
        
        print(self.userData.exerciseData)
    }
}
