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
    let appState: AppState
    
    init(appState: AppState, workout: Binding<Workout>) {
        self.appState = appState
        self._workout = workout
    }
    
    func saveWorkout(workout: Workout) {
        self.workout = workout
        self.appState.saveWorkout(workout: workout)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
