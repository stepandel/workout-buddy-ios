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
                if workout.rounds[0].sets.count != 0 {
                    self.trackWorkoutViewModel.rounds = workout.rounds

                    self.trackWorkoutViewModel.exercises = workout.rounds[0].sets
                    self.trackWorkoutViewModel.numOfRounds = workout.rounds.count
                    
                } else {
                    // TODO: - handle empty workout
                }
                self.trackWorkoutViewModel.currentExercise = self.trackWorkoutViewModel.exercises[0]
                
                // Set default name to completed workout
                self.trackWorkoutViewModel.completedWorkout.name = workout.name
                self.trackWorkoutViewModel.completedWorkout.focus = workout.focus
                self.trackWorkoutViewModel.completedWorkout.type = workout.type
                
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
