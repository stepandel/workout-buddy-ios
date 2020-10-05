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

final class UserData: ObservableObject {
    @Published var isLoggedIn = false
    @Published var workouts: [Workout] = []
    @Published var exercises: [Exercise] = []
    @Published var workoutLog: [CompletedWorkout] = []
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
    
        
    private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? "" {
        didSet {
            UserDefaults.standard.set(self.userId, forKey: "userId")
        }
    }
    
    init() {
        if userId != "" {
            self.isLoggedIn = true
            
            self.getUserData()
            self.getWorkouts()
            self.getExercises()
            self.getWorkoutLog()
        }
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
                
                print("\n \n Success loggin in? \(String(success)) \n \n")
                
                if success {
                    
                    self.userId = id
                    
                    self.getUserData()
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
        firstName = nil
        lastName = nil
        bio = nil
        city = nil
        state = nil
        sport = nil
        weight = nil
        birthDate = nil
        sex = nil
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
        NetworkManager().saveWorkout(workout: completedWorkout.workout, userId: self.userId)
    }
    
    func saveExercise(exercise: Exercise) {
        NetworkManager().saveExercise(exercise: exercise, userId: self.userId)
    }
}
