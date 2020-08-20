//
//  WorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var userData: UserData
    
    @State var workout: Workout // TODO: - how to update this dynamically?\
    @State var duration: Int?
    
    @State var workoutIdx = 0
    @State var isEditPresented = false
    
    var body: some View {
        VStack {
            
            if (duration != nil) {
                if duration! > 0 {
                    HStack {
                        Text("Duration: \(duration!) min")
                            .padding()
                        Spacer()
                    }
                }
            }
            
            HStack {
                Text("Rounds: \(workout.rounds.count)x")
                Spacer()
            }
            .padding()
            
            RoundBlock(rounds: workout.rounds)
//            Spacer()
//                .frame(height: 12.0)
            
            // TODO: - Add data for more rounds
            
            Spacer()
        }
        .navigationBarTitle(Text(workout.name), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.workoutIdx = self.userData.workouts.firstIndex(of: self.workout)!
            self.isEditPresented.toggle()
        }) {
            Text("Edit")
        })
        .sheet(isPresented: self.$isEditPresented) {
            EditWorkoutView(editWorkoutViewModel: EditWorkoutViewModel(workout: self.workout), workoutIdx: self.workoutIdx)
                .environmentObject(self.userData)
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: sampleWorkouts[0], duration: 40).environmentObject(UserData())
    }
}
