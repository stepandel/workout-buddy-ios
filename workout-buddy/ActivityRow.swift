//
//  ActivityRow.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-19.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ActivityRow: View {
    var completedWorkout: CompletedWorkout
    
    @State var dateStr = ""
    @State var workoutStats = WorkoutStats()
    let dateFormatter = DateFormatter()
    
    var body: some View {
//        HStack {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(completedWorkout.workout.name)
                                .font(.title)
                                .padding(.bottom, 4)
                            Text("\(dateStr)")
                                .font(.footnote)
                        }
                        Spacer()
                    }.padding()
                }
//                .background(Constants.Colors.appBackground)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Session Length: " + completedWorkout.stringFormattedTime())
                        Text("Exercises Completed: \(workoutStats.completedExercises.count)")
                        Text("Total Reps: \(workoutStats.repsCompleted)")
                        Text("Total Sets: \(workoutStats.setsCompleted)")
                        Text("Total Weight Lifted: \(workoutStats.weightLifted)")
                    }.padding(.leading)
                    Spacer()
                }.padding()
                .frame(maxWidth: .infinity)
//                .background(Color.white)
            }
//            .background(Color.white)
//            .cornerRadius(20)
//            .shadow(radius: 10)
            .onAppear {
                self.dateFormatter.timeZone = TimeZone.current
                self.dateFormatter.locale = NSLocale.current
                self.dateFormatter.dateFormat = "MMM-d, yyyy"
                
                let date = Date(timeIntervalSince1970: self.completedWorkout.startTS)
                self.dateStr = self.dateFormatter.string(from: date)
                
                self.workoutStats = self.completedWorkout.getWorkoutStats()
            }
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRow(completedWorkout: sampleWorkoutLog[0])
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
