//
//  StatsView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-10-09.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var appState: AppState
    @State var selected = 9
    @State var selectedWeek = "This Week"
    
    var body: some View {
//        List {
            Section(header: Text("Totals")) {
                HStack {
                    Text("Total Workouts Completed")
                    Spacer()
                    Text("\(appState.userData.stats.totalWorkoutsCompleted)")
                }
                HStack {
                    Text("Total Weight Lifted")
                    Spacer()
                    Text("\(appState.userData.stats.totalWeightLifted) kg")
                }
                HStack {
                    Text("Total Reps Completed")
                    Spacer()
                    Text("\(appState.userData.stats.totalRepsCompleted)")
                }
                HStack {
                    Text("Total Sets Completed")
                    Spacer()
                    Text("\(appState.userData.stats.totalSetsCompleted)")
                }
                HStack {
                    Text("Total Active Time")
                    Spacer()
                    Text("\(appState.userData.stats.totalTimeWorkingout / 60) min")
                }
            }
            
            
            Section(header: Text("Weight Lifted (" + selectedWeek + ")")) {
                    
                HStack(spacing: 16) {
                    
                    ForEach(appState.userData.tenWeekRollingStats.weeklyStats.indices, id: \.self) { idx in
                        
                        VStack {
                            
                            Spacer(minLength: 0)
                            
                            if selected == idx {
                                Text("\(appState.userData.tenWeekRollingStats.weeklyStats[idx].stats.totalWeightLifted)")
                                    .font(.footnote)
                                    .padding(.bottom, 5)
                            }
                            
                            Rectangle()
                                .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                                .frame(height: appState.userData.tenWeekRollingStats.normilized(by: .weightLifted)[idx] * 200)
                        }
                        .frame(height: 220)
                        .onTapGesture {
                            selected = idx
                            getSelectedWeekInterval()
                        }
                    }
                }.listRowBackground(Constants.Colors.appBackground)
            }
            Section(header: Text("Reps Completed (" + selectedWeek + ")")) {
                
                
                HStack(spacing: 16) {
                    
                    ForEach(appState.userData.tenWeekRollingStats.weeklyStats.indices, id: \.self) { idx in
                        
                        VStack {
                            
                            Spacer(minLength: 0)
                            
                            if selected == idx {
                                Text("\(appState.userData.tenWeekRollingStats.weeklyStats[idx].stats.totalRepsCompleted)")
                                    .font(.footnote)
                                    .padding(.bottom, 5)
                            }
                            
                            Rectangle()
                                .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                                .frame(height: appState.userData.tenWeekRollingStats.normilized(by: .repsCompleted)[idx] * 200)
                        }
                        .frame(height: 220)
                        .onTapGesture {
                            selected = idx
                            getSelectedWeekInterval()
                        }
                    }
                }.listRowBackground(Constants.Colors.appBackground)
                
            }
            Section(header: Text("Number Of Workouts (" + selectedWeek + ")")) {
                
                HStack(spacing: 16) {
                    
                    ForEach(appState.userData.tenWeekRollingStats.weeklyStats.indices, id: \.self) { idx in
                        
                        VStack {
                            
                            Spacer(minLength: 0)
                            
                            if selected == idx {
                                Text("\(appState.userData.tenWeekRollingStats.weeklyStats[idx].stats.totalWorkoutsCompleted)")
                                    .font(.footnote)
                                    .padding(.bottom, 5)
                            }
                            
                            Rectangle()
                                .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                                .frame(height: appState.userData.tenWeekRollingStats.normilized(by: .workoutsCompleted)[idx] * 200)
                        }
                        .frame(height: 220)
                        .onTapGesture {
                            selected = idx
                            getSelectedWeekInterval()
                        }
                    }
                }.listRowBackground(Constants.Colors.appBackground)
                
            }
            
            Section(header: Text(selectedWeek)) {
                HStack {
                    Text("Workouts Completed")
                    Spacer()
                    Text("\(appState.userData.tenWeekRollingStats.weeklyStats[selected].stats.totalWorkoutsCompleted)")
                }
                HStack {
                    Text("Weight Lifted")
                    Spacer()
                    Text("\(appState.userData.tenWeekRollingStats.weeklyStats[selected].stats.totalWeightLifted) kg")
                }
                HStack {
                    Text("Reps Completed")
                    Spacer()
                    Text("\(appState.userData.tenWeekRollingStats.weeklyStats[selected].stats.totalRepsCompleted)")
                }
                HStack {
                    Text("Sets Completed")
                    Spacer()
                    Text("\(appState.userData.tenWeekRollingStats.weeklyStats[selected].stats.totalSetsCompleted)")
                }
                HStack {
                    Text("Active Time")
                    Spacer()
                    Text("\(appState.userData.tenWeekRollingStats.weeklyStats[selected].stats.totalTimeWorkingout / 60) min")
                }
            }
//        }.listStyle(GroupedListStyle())
//        .navigationBarTitle(Text("Statistics"))
    }
    
    func getSelectedWeekInterval() {
        
        if selected == 9 {
            self.selectedWeek = "This Week"
            return
        }
        
        if let weekEndTS = appState.userData.weekEndTS {
            
            var dateComponentsLast = DateComponents()
            dateComponentsLast.day = -(9 - selected)*7
            dateComponentsLast.second = -1
            var dateComponentsFirst = DateComponents()
            dateComponentsFirst.day = -(9 - selected + 1)*7
            dateComponentsFirst.second = 1
            
            guard let lastDayOfWeek = Calendar.current.date(byAdding: dateComponentsLast, to: Date(timeIntervalSince1970: weekEndTS))
                  , let firstDayOfWeek = Calendar.current.date(byAdding: dateComponentsFirst, to: Date(timeIntervalSince1970: weekEndTS)) else {
                self.selectedWeek = "Week -\(self.selected)"
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MMM-dd"
            
            self.selectedWeek = "\(dateFormatter.string(from: firstDayOfWeek)) - \(dateFormatter.string(from: lastDayOfWeek))"
        } else {
            
            self.selectedWeek = "Week -\(self.selected)"
        }
        
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView().environmentObject(AppState())
    }
}
