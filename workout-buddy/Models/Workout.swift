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
    var notes: String
    var type: String
    var rounds: [Round]
    
    init(name: String = "", focus: String = "", notes: String = "", type: String = "") {
        self.id = UUID().uuidString
        self.name = name
        self.focus = focus
        self.notes = notes
        self.type = type
        
        let newRound = Round()
        
        self.rounds = [newRound]
    }
    
    init(workout: Workout) {
        self.id = UUID().uuidString
        self.name = workout.name
        self.focus = workout.focus
        self.notes = workout.notes
        self.type = workout.type
        self.rounds = workout.rounds
    }
}


// MARK: - Workout manipulation methods

extension Workout {
    mutating func deleteExercise(at offset: IndexSet, in round: Int) {
        self.rounds[round].sets.remove(atOffsets: offset)
    }
    
    mutating func moveExercise(source: IndexSet, destination: Int, in round: Int) {
        self.rounds[round].sets.move(fromOffsets: source, toOffset: destination)
    }
    
    mutating func addRound(after round: Round, copy: Bool) {
        if let roundIdx = self.rounds.firstIndex(of: round) {
            if copy {
                self.rounds.insert(Round(round: round), at: roundIdx + 1)
            } else {
                self.rounds.insert(Round(), at: roundIdx + 1)
            }
        }
    }
    
    mutating func deleteRound(round: Round) {
        if let idx = self.rounds.firstIndex(of: round) {
            self.rounds.remove(at: idx)
            if self.rounds.count == 0 {
                // Add new empty round
                let newRound = Round()
                self.rounds.append(newRound)
            }
        }
    }
}


// MARK: - Round

struct Round: Hashable, Codable, Identifiable {
    var id: String
    var sets: [[ExSet]]
    
    init(){
        self.id = UUID().uuidString
        self.sets = []
    }
    
    init(round: Round) {
        self.id = UUID().uuidString
        self.sets = round.sets
    }
}

func isSameWorkout(w1: Workout, w2: Workout) -> Bool {
    if w1.id == w2.id && w1.name == w2.name {
        
        if w1.rounds.count == w2.rounds.count {
            // Compare each round
            for i in w1.rounds.indices {
                if w1.rounds[i] != w2.rounds[i] {
                    
                    if w1.rounds[i].sets.count != w2.rounds[i].sets.count {
                        return false
                    }
                    
                    for j in w1.rounds[i].sets.indices {
                        if w1.rounds[i].sets[j][0].exId != w2.rounds[i].sets[j][0].exId {
                            return false
                        }
                    }
                }
            }
            
        } else {
            // Compare each round and all rounds. Return true only if all rounds have the same exercises
            
            var longestWorkoutRounds = w1.rounds
            if w1.rounds.count < w2.rounds.count {
                longestWorkoutRounds = w2.rounds
            }
            
            for i in longestWorkoutRounds.indices.dropLast() {
                if w1.rounds[i] != longestWorkoutRounds.last || w2.rounds[i] != longestWorkoutRounds.last {
                    
                    if w1.rounds[i].sets.count != longestWorkoutRounds.last?.sets.count || w2.rounds[i].sets.count != longestWorkoutRounds.last?.sets.count {
                        return false
                    }
                    
                    for j in longestWorkoutRounds[i].sets.indices {
                        if w1.rounds[i].sets[j][0].exId != longestWorkoutRounds.last?.sets[j][0].exId || w2.rounds[i].sets[j][0].exId != longestWorkoutRounds.last?.sets[j][0].exId {
                            return false
                        }
                    }
                }
            }
        }
        
        return true
        
    }
    
    return false
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
