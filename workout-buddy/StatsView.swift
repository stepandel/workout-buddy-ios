//
//  StatsView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-10-09.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var userData: UserData
    @State var weightLiftedByWeek: [CGFloat] = [400, 800, 600, 400, 356, 379, 600, 1005, 580, 740]
    @State var repsCompletedByWeek: [CGFloat] = [1010, 960, 488, 798, 1245, 856, 1157, 950, 1379, 1057]
    @State var workoutsPerWeek: [CGFloat] = [3, 4, 2, 3, 4, 3, 3, 3, 3, 4, 3]
    
    var body: some View {
        List {
            Section(header: Text("Weight Lifted")) {
                HStack {
                    Spacer()
                    CapsuleBarChart(data: weightLiftedByWeek.normilized)
                    Spacer()
                }.listRowBackground(Constants.Colors.appBackground)
            }
            Section(header: Text("Reps Completed")) {
                HStack {
                    Spacer()
                    CapsuleBarChart(data: repsCompletedByWeek.normilized)
                    Spacer()
                }.listRowBackground(Constants.Colors.appBackground)
            }
            Section(header: Text("Number Of Workouts")) {
                HStack {
                    Spacer()
                    CapsuleBarChart(data: workoutsPerWeek.normilized)
                    Spacer()
                }.listRowBackground(Constants.Colors.appBackground)
            }
            Section(header: Text("Totals")) {
                HStack {
                    Text("Total Workouts Completed")
                    Spacer()
                    Text("\(userData.stats.totalWorkoutsCompleted)")
                }
                HStack {
                    Text("Total Weight Lifted")
                    Spacer()
                    Text("\(userData.stats.totalWeightLifted) kg")
                }
                HStack {
                    Text("Total Reps Completed")
                    Spacer()
                    Text("\(userData.stats.totalRepsCompleted)")
                }
                HStack {
                    Text("Total Sets Completed")
                    Spacer()
                    Text("\(userData.stats.totalSetsCompleted)")
                }
                HStack {
                    Text("Total Active Time")
                    Spacer()
                    Text("\(userData.stats.totalTimeWorkingout / 60000) min")
                }
            }
            Section(header: Text("This Week")) {
                HStack {
                    Text("Workouts Completed")
                    Spacer()
                    Text("\(userData.weeklyStats.workoutsCompleted)")
                }
                HStack {
                    Text("Weight Lifted")
                    Spacer()
                    Text("\(userData.weeklyStats.weightLifted) kg")
                }
                HStack {
                    Text("Reps Completed")
                    Spacer()
                    Text("\(userData.weeklyStats.repsCompleted)")
                }
                HStack {
                    Text("Sets Completed")
                    Spacer()
                    Text("\(userData.weeklyStats.setsCompleted)")
                }
                HStack {
                    Text("Active Time")
                    Spacer()
                    Text("\(userData.weeklyStats.timeWorkingout / 60000) min")
                }
            }
        }.listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Statistics"))
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView().environmentObject(UserData())
    }
}
