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
    }
}


// MARK: - Routing

extension TrackWorkout {
    struct Routing {
        var showingModalView = false
        var modalView: ModalView = .workouts
        private(set) var curRoundIdx = 0
        var showingAlert = false
        var showingActionSheet = false
        var actionSheetView: ActionSheetView = .endWorkout
        
        mutating func showWorkoutsModal() {
            self.modalView = .workouts
            self.showingModalView = true
        }
        
        mutating func showExercisesModal(roundIdx: Int) {
            self.curRoundIdx = roundIdx
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
            self.appState.saveCompletedWorkout(completedWorkout: completedWorkout)
            
            // Reset workout data
            self.appState.trackingData.workoutStarted = false
            self.appState.trackingData.reset()
            self.isWorkoutSelected = false

            self.appState.routing.contentView.routeToActivities()
        }
        
        func cancelWorkout() {
            print("Workout cancelled")
            
            // Reset workout data
            self.appState.trackingData.workoutStarted = false
            self.appState.trackingData.reset()
            self.isWorkoutSelected = false
            
            self.appState.routing.contentView.routeToActivities()
        }
        
        
        // MARK: - Appearance
        
        func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
