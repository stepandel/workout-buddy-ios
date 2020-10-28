//
//  NetworkManager.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-02.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI


class NetworkManager {
    
    let baseUrl = "https://21dld2pcsg.execute-api.us-east-2.amazonaws.com/dev/"
    
    func saveNewUserWithoutAccount(id: String) {
        guard let url = URL(string: baseUrl + "saveNewUserWithoutAccount") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveNewUserWithoutAccountRequest = SaveNewUserWithoutAccountRequest(id: id)

        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveNewUserWithoutAccountRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let err = err {
                    print("Error creating new user: \(String(describing: err))")
                }
                print("Save New User Response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func saveNewUser(id: String, pass: String) {
        guard let url = URL(string: baseUrl + "saveNewUser") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveNewUserRequest = SaveNewUserRequest(id: id, password: pass)

        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveNewUserRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let err = err {
                    print("Error creating new user: \(String(describing: err))")
                }
                print("Save New User Response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func checkUser(id: String, pass: String, completion: @escaping((Bool) -> ())) {
        guard let url = URL(string: baseUrl + "checkUser") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let checkUserRequest = CheckUserRequest(id: id, password: pass)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(checkUserRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                
                if let err = err {
                    print("Error: \(String(describing: err))")
                }
                
                if let data = data {
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(CheckUserResponse.self, from: data) {
                        DispatchQueue.main.async {
//                            print(json)
                            completion(json.success)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func saveUser(user: User) {
        guard let url = URL(string: baseUrl + "saveUser") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveUserRequest = SaveUserRequest(user: user)

        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveUserRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let err = err {
                    print("Error saving user: \(String(describing: err))")
                }
                print("SaveUser Response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func getUser(id: String, completion: @escaping(User) -> ()) {
        guard let url = URL(string: baseUrl + "getUser") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let getUserRequest = GetUserRequest(id: id)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(getUserRequest) {
            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let data = data {
                    
//                    let dataAsString = String(data: data, encoding: .utf8)
//                    print(dataAsString)
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(GetUserResponse.self, from: data) {
//                        print(json)
                        DispatchQueue.main.async {
                            completion(json.user)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func uploadUserImage(userId: String, userImage: String) {
        guard let url = URL(string: baseUrl + "updateUserImage") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let uploadUserImageRequest = UploadUserImageRequest(userId: userId, userImage: userImage)

        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(uploadUserImageRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                
                if let err = err {
                    print("Error uploading image: \(String(describing: err))")
                }
                print("Upload image response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func getImage(from urlStr: String, completion: @escaping(UIImage) -> ()) {
        guard let url = URL(string: urlStr) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data,res,err) in
            guard let data = data, err == nil else { return }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    func getWorkouts(userId: String, completion: @escaping([Workout]) -> ()) {
        guard let url = URL(string: baseUrl + "getWorkoutsForUser") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let getWorkoutsRequest = GetWorkoutsRequest(userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(getWorkoutsRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let data = data {
                    
//                    let dataAsString = String(data: data, encoding: .utf8)
//                    print(dataAsString)
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(GetWorkoutResponse.self, from: data) {
//                        print(json)
                        DispatchQueue.main.async {
                            completion(json.workouts)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func getExercises(userId: String, completion: @escaping(([Exercise]) -> ())) {
        guard let url = URL(string: baseUrl + "getExercisesForUser") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let getExercisesRequest = GetExercisesRequest(userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(getExercisesRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let data = data {
                    
//                    let dataAsString = String(data: data, encoding: .utf8)
//                    print(dataAsString)
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(GetExercisesResponse.self, from: data) {
//                        print(json)
                        DispatchQueue.main.async {
                            completion(json.exercises)
                        }
                    }
                }
            }.resume()
        }
    }
    
    
    func getWorkoutLog(userId: String, completion: @escaping(([CompletedWorkout]) -> ())) {
        guard let url = URL(string: baseUrl + "getWorkoutLogForUser") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let getWorkoutLogRequest = GetWorkoutLogRequest(userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(getWorkoutLogRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let data = data {
                    
//                    let dataAsString = String(data: data, encoding: .utf8)
//                    print(dataAsString)
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(GetWorkoutLogResponse.self, from: data) {
//                        print(json)
                        DispatchQueue.main.async {
                            completion(json.completedWorkouts)
                        }
                    }
                }
            }.resume()
        }
    }
    
    
    func saveWorkout(workout: Workout, userId: String) {
        guard let url = URL(string: baseUrl + "saveWorkout") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveWorkoutRequest = SaveWorkoutRequest(workout: workout, userId: userId)

        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveWorkoutRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
               print("Save Workout Response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func saveCompletedWorkout(completedWorkout: CompletedWorkout, userId: String) {
        guard let url = URL(string: baseUrl + "saveCompletedWorkout") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveCompletedWorkoutRequest = SaveCompletedWorkoutRequest(completedWorkout: completedWorkout, userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveCompletedWorkoutRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data, res, err) in
                print("Save Completed Workout Response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func saveExercise(exercise: Exercise, userId: String) {
        guard let url = URL(string: baseUrl + "saveExercise") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveExerciseRequest = SaveExerciseRequest(exercise: exercise, userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveExerciseRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data, res, err) in
                print("Save Completed Workout Response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func saveStats(userId: String, stats: Stats) {
        guard let url = URL(string: baseUrl + "saveStatsForUser") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let saveStatsRequest = SaveStatsRequest(userId: userId, stats: stats)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(saveStatsRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data, res, err) in
                print("Save Stats Response: \(String(describing: res))")
            }.resume()
        }
    }
    
    func getStats(userId: String, completion: @escaping(Stats) -> ()) {
        guard let url = URL(string: baseUrl + "getStatsForUser") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let getStatsRequest = GetStatsRequest(userId: userId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(getStatsRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let data = data {
                    
//                    let dataAsString = String(data: data, encoding: .utf8)
//                    print(dataAsString)
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(GetStatsResponse.self, from: data) {
//                        print(json)
                        DispatchQueue.main.async {
                            completion(json.stats)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func getCompletedWorkoutsAndStatsForUser(userId: String, timezoneOffset: Int, completion: @escaping(([CompletedWorkout], Stats) -> ())) {
        guard let url = URL(string: baseUrl + "getCompletedWorkoutsAndStatsForUser") else { return }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let getCompletedWorkoutsAndStatsRequest = GetCompletedWorkoutsAndStatsRequest(userId: userId, timezoneOffset: timezoneOffset)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(getCompletedWorkoutsAndStatsRequest) {
//            print(jsonData)
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data,res,err) in
                if let data = data {
                    
//                    let dataAsString = String(data: data, encoding: .utf8)
//                    print(dataAsString)
                    
                    let decoder = JSONDecoder()
                    
                    if let json = try? decoder.decode(GetCompletedWorkoutsAndStatsResponse.self, from: data) {
//                        print(json)
                        DispatchQueue.main.async {
                            completion(json.completedWorkouts, json.stats)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func deleteWorkoutFromLog(userId: String, wlId: String) {
        guard let url = URL(string: baseUrl + "deleteWorkoutFromLog") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let deleteWorkoutFromLogRequest = DeleteWorkoutFromLogRequest(userId: userId, wlId: wlId)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(deleteWorkoutFromLogRequest) {
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data, res, err) in
                print("Delete Workout From Log Response: \(String(describing: res))")
            }.resume()
        }
    }
}
