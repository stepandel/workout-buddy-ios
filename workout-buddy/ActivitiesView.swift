//
//  HomeView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ActivitiesView: View {
    
    @EnvironmentObject var appState: AppState
    
//    init() {
//        if #available(iOS 14.0, *) {
//            UINavigationBar.appearance().backgroundColor  = UIColor(Constants.Colors.appBackground)
//        }
//    }
    
    var body: some View {
        NavigationView {
            if appState.userData.workoutLog.count > 0 {
                List {
                    ForEach(appState.userData.workoutLog.reversed(), id:\.wlId) { completedWorkout in
                        Section(header: Text("")) {
                            NavigationLink(destination: CompletedWorkoutView(completedWorkout: completedWorkout)) {
                                ActivityRow(completedWorkout: completedWorkout)
                            }
                        }
                    }.onDelete { self.deleteWorkout(at: $0) }
    //                .listRowBackground(Constants.Colors.appBackground)
                }
                .navigationBarTitle("Completed Workouts")
            } else {
                Text("Complete a Workout!")
                    .navigationBarTitle("Completed Workouts")
            }
        }
    }
    
    func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { i in
            appState.userData.deleteWorkoutLogItem(completedWorkout: self.appState.userData.workoutLog.reversed()[i])
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView().environmentObject(AppState())
    }
}
