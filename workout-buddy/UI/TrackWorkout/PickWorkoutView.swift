//
//  PickWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-12.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct PickWorkoutView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var trackWorkoutViewModel: TrackWorkout.ViewModel
    
    @Environment(\.presentationMode) var isPresentationMode
    
    var body: some View {
        List {
            ForEach(appState.userData.workouts) { workout in
                Button(action: {
                    print("Button pressed")
                    self.appState.trackingData.workout = workout
                    self.trackWorkoutViewModel.isWorkoutSelected = true
                    self.appState.trackingData.workout.rounds.forEach({ round in
                        print("Round indices: \(round.sets.indices)")
                        round.sets.indices.forEach({ i in
                            print("Index: \(i)")
                        })
                    })
                    self.isPresentationMode.wrappedValue.dismiss()
                }){
                    WorkoutRow(workout: workout)
                }
            }.onDelete { appState.deleteWorkouts(at: $0) }
        }
    }
}

struct PickWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        PickWorkoutView(trackWorkoutViewModel: TrackWorkout.ViewModel(appState: AppState()))
            .environmentObject(AppState())
    }
}
