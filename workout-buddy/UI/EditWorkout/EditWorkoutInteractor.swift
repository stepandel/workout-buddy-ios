//
//  EditWorkoutInteractor.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-21.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct EditWorkoutInteractor {
    @Binding var workout: Workout
    let parentView: ParentView
    let appState: AppState
    
    init(appState: AppState, workout: Binding<Workout>, parentView: ParentView) {
        self.appState = appState
        self._workout = workout
        self.parentView = parentView
    }
    
    func saveWorkout(workout: Workout) {
        self.workout = workout
        self.appState.saveWorkout(workout: workout)
    }
    
    func showExerciseModal(roundIdx: Int) {
        switch self.parentView {
        case .tracking:
            self.appState.routing.trackWorkout.showExercisesModal(roundIdx: roundIdx)
        case .edit:
            self.appState.routing.editWorkout.showExercisesModal(roundIdx: roundIdx)
        }
        self.appState.routing.editWorkout.showSelectExercisesSheet()
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension EditWorkoutInteractor {
    enum ParentView {
        case tracking
        case edit
    }
}
