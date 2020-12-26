//
//  ActivitiesViewModel.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-15.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

extension Activities {
    class ViewModel: ObservableObject {
        
        // State
        @Published var workoutLog: [[CompletedWorkout]]
        
        // Misc
        let appState: AppState
        var completedWorkouts: [CompletedWorkout]
        
        init(appState: AppState) {
            self.appState = appState
            self.completedWorkouts = appState.userData.workoutLog
            self.workoutLog = []
            var curWeek = Date().weekOfYear()
            var curWeekYear = Date().yearForWeekOfYear()
            var weekIdx = 0
            self.completedWorkouts.reversed().forEach { workout in
                (curWeek, curWeekYear, weekIdx) = workoutLog.addToLog(curWeek: curWeek, curWeekYear: curWeekYear, workout: workout, at: weekIdx)
            }
        }
        
//        func deleteWorkout(at offsets: IndexSet) {
//            offsets.forEach { i in
//                self.appState.deleteWorkoutLogItem(completedWorkout: self.workoutLog[i])
//                self.completedWorkouts.remove(at: self.completedWorkouts.count - i - 1)
//            }
//            self.workoutLog.remove(atOffsets: offsets)
//        }
    }
}
