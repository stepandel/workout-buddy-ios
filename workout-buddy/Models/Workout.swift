//
//  Workout.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct Workout: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var focus: String
    var type: String
    var rounds: [Round]
    
    init(name: String, focus: String = "", type: String = "") {
        self.id = UUID().uuidString
        self.name = name
        self.focus = focus
        self.type = type
        
        let newRound = Round()
        
        self.rounds = [newRound]
    }
}

struct Round: Hashable, Codable, Identifiable {
    var id: String
    var sets: [ExSet]
    
    init(){
        self.id = UUID().uuidString
        self.sets = []
    }
}

//enum WorkoutType: String, Codable, Hashable {
//    case rounds = "Round(s)"
//    case sets = "Set(s)"
//    case cardio = "Cardio"
//}

extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}
