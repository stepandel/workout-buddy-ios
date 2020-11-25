//
//  UserData.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-13.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

extension AppState {
    struct UserData {
        var isLoggedIn = false
        var didCreateAccount = false
        var workouts: [Workout] = []
        var exercises: [Exercise] = []
        var allExercises: [Exercise] = exercisesDB
        var workoutLog: [CompletedWorkout] = []
        var user: User
        var stats: Stats
        var weekEndTS: Double?
        var tenWeekRollingStats: TenWeekRollingStats
        var exerciseData: [String: ExerciseStats] = [:]
        
            
        var userId: String = UserDefaults.standard.string(forKey: "userId") ?? "" {
            didSet {
                UserDefaults.standard.set(self.userId, forKey: "userId")
            }
        }
        
        init() {
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
            }
        }
    }
}


extension AppState {
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
