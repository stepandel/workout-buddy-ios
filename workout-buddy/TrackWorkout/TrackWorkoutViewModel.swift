//
//  TrackWorkoutViewModel.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-13.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

// MARK: - Modals

extension TrackWorkout {
    enum ModalView {
        case workouts
        case exercises
    }

    enum ActionSheetView {
        case startWorkout
        case endWorkout
        case addRound
    }
}


// MARK: - Routing

extension TrackWorkout {
    struct Routing {
        var showingModalView = false
        var modalView: ModalView = .workouts
        var showingAlert = false
        var showingActionSheet = false
        var actionSheetView: ActionSheetView = .addRound
        
        mutating func showWorkoutsModal() {
            self.modalView = .workouts
            self.showingModalView = true
        }
        
        mutating func showExercisesModal() {
            self.modalView = .exercises
            self.showingModalView = true
        }
        
        mutating func showCancelWorkoutAlert() {
            self.showingAlert = true
        }
        
        mutating func showStartWorkoutActionSheet() {
            self.actionSheetView = .startWorkout
            self.showingActionSheet = true
        }
        
        mutating func showEndWorkoutActionSheet() {
            self.actionSheetView = .endWorkout
            self.showingActionSheet = true
        }
        
        mutating func showAddRoundActionSheet() {
            self.actionSheetView = .addRound
            self.showingActionSheet = true
        }
    }
}


// MARK: - ViewModel

extension TrackWorkout {
    class ViewModel: ObservableObject {
        
        // State
        @Published var workout: Workout
        @Published var isWorkoutSelected: Bool
        @Published var workoutStarted = false
        @Published var currentRound = 0
        @Published var curExIdx = 0
        @Published var addExAfterIdx = 0
        @Published var startTime: Double = 0
        
        // Misc
        let appState: AppState
        
        init(appState: AppState) {
            self.appState = appState
            
            workout = Workout(name: "")
            isWorkoutSelected = false
        }
        
        
        // MARK: - Rounds
        
        func completeExercise(at offsets: IndexSet) {
            if (!self.workoutStarted) { self.startWorkout() }
            
            // Start new round
            if (self.curExIdx + 1 >= self.workout.rounds[self.currentRound].sets.count) {
                
                // Continue to the next round
                if (self.currentRound + 1 < self.workout.rounds.count) { // Check if next round is avaiable
                    
                    self.currentRound += 1
                    self.curExIdx = 0
                }
                
            } else { // Continue to the next exercise in the round
                self.curExIdx += 1
            }
        }
        
        func addExercise(round: Int, addLast: Bool) {
            self.currentRound = round
            self.addExAfterIdx = addLast ? self.workout.rounds[round].sets.count - 1 : self.curExIdx
            self.appState.routing.trackWorkout.showExercisesModal()
        }
        
        func skipExercise(at offset: IndexSet, in round: Int) {
            offset.forEach { i in
                self.workout.rounds[round].sets[i][0].skipped = true
                self.workout.rounds[round].sets[i][0].completed = false
            }
        }
        
        func deleteExercise(at offset: IndexSet, in round: Int) {
            self.workout.rounds[round].sets.remove(atOffsets: offset)
        }
        
        func moveExercise(source: IndexSet, destination: Int, in round: Int) {
            self.workout.rounds[round].sets.move(fromOffsets: source, toOffset: destination)
        }
        
        func addRound(copyRound: Bool) {
            var newRound = Round()
            if copyRound {
                newRound.sets = self.workout.rounds[self.currentRound].sets
            }
            self.workout.rounds.insert(newRound, at: self.currentRound + 1)
            self.currentRound += 1
            self.curExIdx = 0
        }
        
        func deleteRound(round: Int) {
            self.workout.rounds.remove(at: round)
            if self.workout.rounds.count == 0 {
                // Add new empty round
                let newRound = Round()
                self.workout.rounds.append(newRound)
            }
            
            self.currentRound = self.currentRound == 0 ? self.currentRound : self.currentRound - 1
        }
        
        
        // MARK: - Workout
        
        func startWorkout() {
            if !self.workoutStarted {
                // Start timer
                print("Timer: \(Date().timeIntervalSince1970)")
                self.startTime = Date().timeIntervalSince1970
                
                self.appState.routing.trackWorkout.showStartWorkoutActionSheet()
            }
            
            self.workoutStarted = true
        }
        
        func completeWorkout() {
            print("Workout complete")
            
            // Stop timer
            let currentTime = Date().timeIntervalSince1970
            let workoutTime = Int(round(currentTime - self.startTime))
            
            // Save workout to log
            let completedWorkout = CompletedWorkout(workout: self.workout, startTS: self.startTime, time: workoutTime)
            print("Completed workout: \(completedWorkout)")
            self.appState.userData.saveCompletedWorkout(completedWorkout: completedWorkout)
            
            // Reset workout data
            self.workoutStarted = false
            self.workout = Workout(name: "")
            self.isWorkoutSelected = false

            self.appState.userData.trackingStatus.started = false
            self.appState.userData.trackingStatus.new = true
            self.appState.routing.contentView.routeToActivities()
        }
        
        func cancelWorkout() {
            print("Workout cancelled")
            
            // Reset workout data
            self.workoutStarted = false
            self.workout = Workout(name: "")
            self.isWorkoutSelected = false
            self.currentRound = 0
            self.curExIdx = 0
            
            self.appState.userData.trackingStatus.started = false
            self.appState.userData.trackingStatus.new = true
            self.appState.routing.contentView.routeToActivities()
        }
        
        
        // MARK: - Appearance
        
        func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
