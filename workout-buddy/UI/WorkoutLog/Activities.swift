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
            List {
                ForEach(viewModel.workoutLog, id: \.self) { week in
                    Section(header: Text(viewModel.weekStr(weekIdx: viewModel.workoutLog.firstIndex(of: week)!))) {
                        
                        if viewModel.workoutLog.firstIndex(of: week) == 0 && !appState.userData.didWorkoutToday {
                            self.nonCompletedWorkutLogRow(title: "Nothing Scheduled", dateStr: "Today")
                        }
                        
                        else if week.workouts.isEmpty {
                            self.nonCompletedWorkutLogRow(title: "Rest Week", dateStr: nil)
                        }
                        
                        ForEach(week.workouts, id:\.wlId) { completedWorkout in
                            NavigationLink(destination: CompletedWorkoutView(viewModel: viewModel, workoutLogIdx: self.appState.userData.workoutLog.firstIndex(of: completedWorkout)!, weekIdx: viewModel.workoutLog.firstIndex(of: week)!).environmentObject(self.appState)) {
                                self.completedWorkoutLogRow(completedWorkout: completedWorkout)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Completed Workouts")
        }
    }
}


// MARK: - Subviews

extension Activities {
    private func completedWorkoutLogRow(completedWorkout: CompletedWorkout) -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .padding()
            VStack(alignment: .leading) {
                Text("\(self.viewModel.getWeekDayStr(timestamp: completedWorkout.startTS))")
                    .font(.footnote)
                    .padding(.bottom, 4)
                Text("\(completedWorkout.workout.focus)")
                    .font(.title)
            }
            .padding()
        }
    }
    
    private func nonCompletedWorkutLogRow(title: String, dateStr: String?) -> some View {
        HStack {
            Image(systemName: "circle")
                .padding()
            VStack(alignment: .leading) {
                if dateStr != nil {
                    Text("\(dateStr!)")
                        .padding(.bottom)
                        .font(.footnote)
                }
                Text("\(title)")
                    .foregroundColor(Color.gray)
                    .font(.title)
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Activities(viewModel: .init(appState: AppState())).environmentObject(AppState())
    }
}
