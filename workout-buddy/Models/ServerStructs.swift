//
//  ServerStructs.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-10-03.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct SaveNewUserRequest: Encodable {
    var user = ["id": "", "password": ""]
    
    init(id: String, password: String) {
        self.user["id"] = id
        self.user["password"] = password
    }
}

struct CheckUserRequest: Encodable {
    var user = ["id": "", "password": ""]
    
    init(id: String, password: String) {
        self.user["id"] = id
        self.user["password"] = password
    }
}

struct CheckUserResponse: Decodable {
    var success: Bool
}

struct User: Identifiable, Codable {
    var id: String
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
    
    init(_ id: String, firstName: String?, lastName: String?, bio: String?, city: String?, state: String?, sport: String?, weight: Double?, birthDate: Date?, sex: String?, profileImageUrl: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.city = city
        self.state = state
        self.sport = sport
        self.weight = weight
        self.birthDate = birthDate
        self.sex = sex
        self.profileImageUrl = profileImageUrl
    }
}

struct SaveUserRequest: Encodable {
    var user: User
    
    init(user: User) {
        self.user = user
    }
}

struct GetUserRequest: Encodable {
    var id: String
    
    init(id: String) {
        self.id = id
    }
}

struct GetUserResponse: Decodable {
    var user: User
}

struct UploadUserImageRequest: Encodable {
    var userId: String
    var userImage: String
    
    init(userId: String, userImage: String) {
        self.userId = userId
        self.userImage = userImage
    }
}

struct GetWorkoutsRequest: Encodable {
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}

struct GetWorkoutResponse: Decodable {
    var workouts: [Workout]
}

struct GetExercisesRequest: Encodable {
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}

struct GetExercisesResponse: Decodable {
    var exercises: [Exercise]
}

struct GetWorkoutLogRequest: Encodable {
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}

struct GetWorkoutLogResponse: Decodable {
    var completedWorkouts: [CompletedWorkout]
}

struct SaveWorkoutRequest: Encodable {
    var workout: Workout
    var userId: String
    
    init(workout: Workout, userId: String) {
        self.workout = workout
        self.userId = userId
    }
}

struct SaveExerciseRequest: Encodable {
    var exercise: Exercise
    var userId: String
    
    init(exercise: Exercise, userId: String) {
        self.exercise = exercise
        self.userId = userId
    }
}

struct SaveCompletedWorkoutRequest: Encodable {
    var completedWorkout: CompletedWorkoutShort
    var userId: String
    
    init(completedWorkout: CompletedWorkout, userId: String) {
        self.completedWorkout = CompletedWorkoutShort(wlId: completedWorkout.wlId, workoutId: completedWorkout.workout.id, time: completedWorkout.time, startTS: completedWorkout.startTS)
        self.userId = userId
    }
}

struct SaveStatsRequest: Encodable {
    var userId: String
    var stats: Stats
    
    init(userId: String, stats: Stats) {
        self.userId = userId
        self.stats = stats
    }
}

struct GetStatsRequest: Encodable {
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}

struct GetStatsResponse: Decodable {
    var stats: Stats
}

struct GetCompletedWorkoutsAndStatsRequest: Encodable {
    var userId: String
    var timezoneOffset: Int
    
    init(userId: String, timezoneOffset: Int) {
        self.userId = userId
        self.timezoneOffset = timezoneOffset
    }
}

struct GetCompletedWorkoutsAndStatsResponse: Decodable {
    var completedWorkouts: [CompletedWorkout]
    var stats: Stats
}
