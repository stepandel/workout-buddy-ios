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
        @Published var isWorkoutSelected: Bool
        
        // Misc
        let appState: AppState
        
        init(appState: AppState) {
            self.appState = appState
            
            isWorkoutSelected = false
        }
        
        
        // MARK: - Rounds
        
        func completeExercise(at offsets: IndexSet) {
            if (!self.appState.trackingData.workoutStarted) { self.startWorkout() }
            
            // Start new round
            if (self.appState.trackingData.curExIdx + 1 >= self.appState.trackingData.workout.rounds[self.appState.trackingData.currentRound].sets.count) {
                
                // Continue to the next round
                if (self.appState.trackingData.currentRound + 1 < self.appState.trackingData.workout.rounds.count) { // Check if next round is avaiable
                    
                    self.appState.trackingData.currentRound += 1
                    self.appState.trackingData.curExIdx = 0
                }
                
            } else { // Continue to the next exercise in the round
                self.appState.trackingData.curExIdx += 1
            }
        }
        
        func addExercise(round: Int, addLast: Bool) {
            self.appState.trackingData.currentRound = round
            self.appState.trackingData.addExAfterIdx = addLast ? self.appState.trackingData.workout.rounds[round].sets.count - 1 : self.appState.trackingData.curExIdx
            self.appState.routing.trackWorkout.showExercisesModal()
        }
        
        func skipExercise(at offset: IndexSet, in round: Int) {
            offset.forEach { i in
                self.appState.trackingData.workout.rounds[round].sets[i][0].skipped = true
                self.appState.trackingData.workout.rounds[round].sets[i][0].completed = false
            }
        }
        
        func deleteExercise(at offset: IndexSet, in round: Int) {
            self.appState.trackingData.workout.rounds[round].sets.remove(atOffsets: offset)
        }
        
        func moveExercise(source: IndexSet, destination: Int, in round: Int) {
            self.appState.trackingData.workout.rounds[round].sets.move(fromOffsets: source, toOffset: destination)
        }
        
        func addRound(copyRound: Bool) {
            var newRound = Round()
            if copyRound {
                newRound.sets = self.appState.trackingData.workout.rounds[self.appState.trackingData.currentRound].sets
            }
            self.appState.trackingData.workout.rounds.insert(newRound, at: self.appState.trackingData.currentRound + 1)
            self.appState.trackingData.currentRound += 1
            self.appState.trackingData.curExIdx = 0
        }
        
        func deleteRound(round: Int) {
            self.appState.trackingData.workout.rounds.remove(at: round)
            if self.appState.trackingData.workout.rounds.count == 0 {
                // Add new empty round
                let newRound = Round()
                self.appState.trackingData.workout.rounds.append(newRound)
            }
            
            self.appState.trackingData.currentRound = self.appState.trackingData.currentRound == 0 ? self.appState.trackingData.currentRound : self.appState.trackingData.currentRound - 1
        }
        
        
        // MARK: - Workout
        
        func startWorkout() {
            if !self.appState.trackingData.workoutStarted {
                // Start timer
                print("Timer: \(Date().timeIntervalSince1970)")
                self.appState.trackingData.startTime = Date().timeIntervalSince1970
            }
            
            self.appState.trackingData.workoutStarted = true
        }
        
        func completeWorkout() {
            print("Workout complete")
            
            // Stop timer
            let currentTime = Date().timeIntervalSince1970
            let workoutTime = Int(round(currentTime - self.appState.trackingData.startTime))
            
            // Save workout to log
            let completedWorkout = CompletedWorkout(workout: self.appState.trackingData.workout, startTS: self.appState.trackingData.startTime, time: workoutTime)
            print("Completed workout: \(completedWorkout)")
            self.appState.userData.saveCompletedWorkout(completedWorkout: completedWorkout)
            
            // Reset workout data
            self.appState.trackingData.workoutStarted = false
            self.appState.trackingData.reset()
            self.isWorkoutSelected = false

            self.appState.userData.trackingStatus.started = false
            self.appState.userData.trackingStatus.new = true
            self.appState.routing.contentView.routeToActivities()
        }
        
        func cancelWorkout() {
            print("Workout cancelled")
            
            // Reset workout data
            self.appState.trackingData.workoutStarted = false
            self.appState.trackingData.reset()
            self.isWorkoutSelected = false
            
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
