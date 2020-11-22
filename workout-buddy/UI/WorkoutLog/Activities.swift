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
                    ForEach(viewModel.workoutLog, id:\.wlId) { completedWorkout in
                        Section(header: Text("")) {
                            NavigationLink(destination: CompletedWorkoutView(completedWorkout: completedWorkout).environmentObject(self.appState)) {
                                ActivityRow(completedWorkout: completedWorkout)
                            }
                        }
                    }.onDelete { self.viewModel.deleteWorkout(at: $0) }
    //                .listRowBackground(Constants.Colors.appBackground)
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
