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
    
    var body: some View {
        List {
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
