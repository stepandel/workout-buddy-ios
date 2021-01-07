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
                        if week.id > 1 && week.items.isEmpty {
                            self.nonCompletedWorkutLogRow(title: "Rest Week", dateStr: nil)
                        }
                        
                        ForEach(week.items, id:\.self) { day in
                            ForEach(day, id:\.wlId) { item in
                                if item.placeholder != nil {
                                    self.nonCompletedWorkutLogRow(title: "Nothing Scheduled", dateStr: self.viewModel.getWeekDayStr(timestamp: item.startTS))
                                } else if item.time == nil {
                                    self.nonCompletedWorkutLogRow(title: item.workout.focus, dateStr: self.viewModel.getWeekDayStr(timestamp: item.startTS))
                                } else {
                                    NavigationLink(destination: CompletedWorkoutView(viewModel: viewModel, workoutLogIdx: self.appState.userData.workoutLog.firstIndex(of: item)!, weekIdx: viewModel.workoutLog.firstIndex(of: week)!).environmentObject(self.appState)) {
                                        self.completedWorkoutLogRow(completedWorkout: item)
                                    }
                                }
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
    private func completedWorkoutLogRow(completedWorkout: WorkoutLogItem) -> some View {
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
