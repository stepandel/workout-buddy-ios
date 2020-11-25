//
//  ExerciseStatsView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-25.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ExerciseStatsView: View {
    @State var exerciseStats: ExerciseStats
    
    var body: some View {
        List {
            if exerciseStats.volume > 0 {
                HStack {
                    Text("Volume (kg): ")
                    Spacer()
                    Text("\(exerciseStats.volume)")
                }
            }
            if exerciseStats.maxWeight > 0 {
                HStack {
                    Text("Max Weight (kg): ")
                    Spacer()
                    Text("\(exerciseStats.maxWeight)")
                }
            }
            if exerciseStats.oneRM > 0 {
                HStack {
                    Text("1 RM (kg): ")
                    Spacer()
                    Text("\(exerciseStats.oneRM)")
                }
            }
            if exerciseStats.totalReps > 0 {
                HStack {
                    Text("Total Reps: ")
                    Spacer()
                    Text("\(exerciseStats.totalReps)")
                }
            }
            if exerciseStats.maxReps > 0 {
                HStack {
                    Text("Max Reps: ")
                    Spacer()
                    Text("\(exerciseStats.maxReps)")
                }
            }
            if exerciseStats.totalTime > 0 {
                HStack {
                    Text("Total Time (s): ")
                    Spacer()
                    Text("\(exerciseStats.totalTime)")
                }
            }
            if exerciseStats.maxTime > 0 {
                HStack {
                    Text("Max Time (s): ")
                    Spacer()
                    Text("\(exerciseStats.maxTime)")
                }
            }
            if exerciseStats.totalSets > 0 {
                HStack {
                    Text("Total Sets: ")
                    Spacer()
                    Text("\(exerciseStats.totalSets)")
                }
            }
        }
    }
}

struct ExerciseStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseStatsView(exerciseStats: ExerciseStats())
    }
}
