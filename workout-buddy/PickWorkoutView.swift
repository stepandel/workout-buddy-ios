//
//  PickWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-12.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct PickWorkoutView: View {
    var workouts: [Workout]
    @ObservedObject var trackWorkoutViewModel: TrackWorkoutViewModel
    
    @Environment(\.presentationMode) var isPresentationMode
    
    var body: some View {
        List(workouts) { workout in
            Button(action: {
                print("Button pressed")
                self.trackWorkoutViewModel.workout = workout
                self.trackWorkoutViewModel.isWorkoutSelected = true
                if let rounds = workout.rounds {
                    self.trackWorkoutViewModel.rounds = rounds
                    self.trackWorkoutViewModel.exercises = rounds[0].sets ?? workout.sets
                    if (rounds.count != 0 ) {
                        self.trackWorkoutViewModel.rounds.removeFirst()
                    }
                } else {
                    self.trackWorkoutViewModel.exercises = workout.sets
                }
                
                self.isPresentationMode.wrappedValue.dismiss()
            }){
                WorkoutRow(workout: workout)
            }
        }
    }
}

struct PickWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        PickWorkoutView(workouts: sampleWorkouts, trackWorkoutViewModel: TrackWorkoutViewModel())
    }
}
