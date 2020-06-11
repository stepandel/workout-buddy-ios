//
//  NetworkManager.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-02.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI


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
        self.completedWorkout = CompletedWorkoutShort(wlId: completedWorkout.wlId, workoutId: completedWorkout.workout.id, time: completedWorkout.time, completionTs: completedWorkout.completionTs)
        self.userId = userId
    }
}

class NetworkManager {
    
    func getWorkouts(userId: String, completion: @escaping([Workout]) -> ()) {
        guard let url = URL(string: "https://21dld2pcsg.execute-api.us-east-2.amazonaws.com/dev/getWorkoutsForUser") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let getWorkoutsRequest = GetWorkoutsRequest(userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(getWorkoutsRequest) {
            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let data = data {
                    
                    let dataAsString = String(data: data, encoding: .utf8)
                    print(dataAsString)
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(GetWorkoutResponse.self, from: data) {
                        print(json)
                        DispatchQueue.main.async {
                            completion(json.workouts)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func getExercises(userId: String, completion: @escaping(([Exercise]) -> ())) {
        guard let url = URL(string: "https://21dld2pcsg.execute-api.us-east-2.amazonaws.com/dev/getExercisesForUser") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let getExercisesRequest = GetExercisesRequest(userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(getExercisesRequest) {
            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let data = data {
                    
                    let dataAsString = String(data: data, encoding: .utf8)
                    print(dataAsString)
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(GetExercisesResponse.self, from: data) {
                        print(json)
                        DispatchQueue.main.async {
                            completion(json.exercises)
                        }
                    }
                }
            }.resume()
        }
    }
    
    
    func getWorkoutLog(userId: String, completion: @escaping(([CompletedWorkout]) -> ())) {
        guard let url = URL(string: "https://21dld2pcsg.execute-api.us-east-2.amazonaws.com/dev/getWorkoutLogForUser") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let getWorkoutLogRequest = GetWorkoutLogRequest(userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(getWorkoutLogRequest) {
            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let data = data {
                    
                    let dataAsString = String(data: data, encoding: .utf8)
                    print(dataAsString)
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(GetWorkoutLogResponse.self, from: data) {
                        print(json)
                        DispatchQueue.main.async {
                            completion(json.completedWorkouts)
                        }
                    }
                }
            }.resume()
        }
    }
    
    
    func saveWorkout(workout: Workout, userId: String) {
        guard let url = URL(string: "https://21dld2pcsg.execute-api.us-east-2.amazonaws.com/dev/saveWorkout") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveWorkoutRequest = SaveWorkoutRequest(workout: workout, userId: userId)

        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveWorkoutRequest) {
            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
               print("Save Workout Response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func saveCompletedWorkout(completedWorkout: CompletedWorkout, userId: String) {
        guard let url = URL(string: "https://21dld2pcsg.execute-api.us-east-2.amazonaws.com/dev/saveCompletedWorkout") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveCompletedWorkoutRequest = SaveCompletedWorkoutRequest(completedWorkout: completedWorkout, userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveCompletedWorkoutRequest) {
            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data, res, err) in
                print("Save Completed Workout Response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func saveExercise(exercise: Exercise, userId: String) {
        guard let url = URL(string: "https://21dld2pcsg.execute-api.us-east-2.amazonaws.com/dev/saveExercise") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveExerciseRequest = SaveExerciseRequest(exercise: exercise, userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveExerciseRequest) {
            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data, res, err) in
                print("Save Completed Workout Response: \(String(describing: res))")
            }.resume()
        }
    }
}
