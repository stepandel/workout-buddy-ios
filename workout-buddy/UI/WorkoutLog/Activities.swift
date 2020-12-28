//
//  HomeView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct Activities: View {
    
    @EnvironmentObject var appState: AppState
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.workoutLog.count > 0 {
                List {
                    ForEach(viewModel.workoutLog, id: \.self) { week in
                        Section(header: Text(viewModel.weekStr(weekIdx: viewModel.workoutLog.firstIndex(of: week)!))) {
                            ForEach(week, id:\.wlId) { completedWorkout in
                                NavigationLink(destination: CompletedWorkoutView(viewModel: viewModel, workoutLogIdx: self.appState.userData.workoutLog.firstIndex(of: completedWorkout)!, weekIdx: viewModel.workoutLog.firstIndex(of: week)!).environmentObject(self.appState)) {
                                    WorkoutLogRow(completedWorkout: completedWorkout)
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Completed Workouts")
            } else {
                Text("Complete a Workout!")
                    .navigationBarTitle("Completed Workouts")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Activities(viewModel: .init(appState: AppState())).environmentObject(AppState())
    }
}
