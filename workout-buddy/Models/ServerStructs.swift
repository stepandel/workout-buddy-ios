//
//  ServerStructs.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-10-03.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct SaveNewUserWithoutAccountRequest: Encodable {
    var id: String
    
    init(id: String) {
        self.id = id
    }
}

struct SaveNewUserRequest: Encodable {
    var user = ["id": "", "password": ""]
    var deviceId: String?
    
    init(id: String, password: String, deviceId: String?) {
        self.user["id"] = id
        self.user["password"] = password
        self.deviceId = deviceId
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

struct UserRequest: Identifiable, Codable {
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
    var user: UserRequest
    
    init(user: UserRequest) {
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
    var user: UserRequest
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

struct DeleteWorkoutsRequest: Encodable {
    var userId: String
    var workoutIds: [String]
    
    init(userId: String, workoutIds: [String]) {
        self.userId = userId
        self.workoutIds = workoutIds
    }
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
    var workoutLog: [WorkoutLogItem]
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

struct SaveWorkoutLogItemRequest: Encodable {
    var workoutLogItem: WorkoutLogItemShort
    var userId: String
    
    init(workoutLogItem: WorkoutLogItem, userId: String) {
        self.workoutLogItem = WorkoutLogItemShort(wlId: workoutLogItem.wlId, workoutId: workoutLogItem.workout.id, time: workoutLogItem.time, startTS: workoutLogItem.startTS)
        self.userId = userId
    }
}

extension SaveWorkoutLogItemRequest {
    struct WorkoutLogItemShort: Codable {
        var wlId: String
        var workoutId: String
        var time: Int?
        var startTS: Double
        
        init(wlId: String, workoutId: String, time: Int?, startTS: Double) {
            self.wlId = wlId
            self.workoutId = workoutId
            self.time = time
            self.startTS = startTS
        }
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
    var workoutLog: [WorkoutLogItem]
    var stats: Stats
}

struct DeleteWorkoutFromLogRequest: Encodable {
    var userId: String
    var wlId: String
    
    init(userId: String, wlId: String) {
        self.userId = userId
        self.wlId = wlId
    }
}
