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
    @State var selected = 9
    @State var selectedWeek = "This Week"
    
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
                    Text("\(userData.stats.totalTimeWorkingout / 60) min")
                }
            }
            
            
            Section(header: Text("Weight Lifted (" + selectedWeek + ")")) {
                    
                HStack(spacing: 16) {
                    
                    ForEach(userData.tenWeekRollingStats.stats.indices, id: \.self) { idx in
                        
                        VStack {
                            
                            Spacer(minLength: 0)
                            
                            if selected == idx {
                                Text("\(userData.tenWeekRollingStats.stats[idx].weightLifted)")
                                    .font(.footnote)
                                    .padding(.bottom, 5)
                            }
                            
                            Rectangle()
                                .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                                .frame(height: userData.tenWeekRollingStats.normilized(by: .weightLifted)[idx] * 200)
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
                    
                    ForEach(userData.tenWeekRollingStats.stats.indices, id: \.self) { idx in
                        
                        VStack {
                            
                            Spacer(minLength: 0)
                            
                            if selected == idx {
                                Text("\(userData.tenWeekRollingStats.stats[idx].repsCompleted)")
                                    .font(.footnote)
                                    .padding(.bottom, 5)
                            }
                            
                            Rectangle()
                                .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                                .frame(height: userData.tenWeekRollingStats.normilized(by: .repsCompleted)[idx] * 200)
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
                    
                    ForEach(userData.tenWeekRollingStats.stats.indices, id: \.self) { idx in
                        
                        VStack {
                            
                            Spacer(minLength: 0)
                            
                            if selected == idx {
                                Text("\(userData.tenWeekRollingStats.stats[idx].workoutsCompleted)")
                                    .font(.footnote)
                                    .padding(.bottom, 5)
                            }
                            
                            Rectangle()
                                .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                                .frame(height: userData.tenWeekRollingStats.normilized(by: .workoutsCompleted)[idx] * 200)
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
                    Text("\(userData.tenWeekRollingStats.stats[selected].workoutsCompleted)")
                }
                HStack {
                    Text("Weight Lifted")
                    Spacer()
                    Text("\(userData.tenWeekRollingStats.stats[selected].weightLifted) kg")
                }
                HStack {
                    Text("Reps Completed")
                    Spacer()
                    Text("\(userData.tenWeekRollingStats.stats[selected].repsCompleted)")
                }
                HStack {
                    Text("Sets Completed")
                    Spacer()
                    Text("\(userData.tenWeekRollingStats.stats[selected].setsCompleted)")
                }
                HStack {
                    Text("Active Time")
                    Spacer()
                    Text("\(userData.tenWeekRollingStats.stats[selected].timeWorkingout / 60) min")
                }
            }
        }.listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Statistics"))
    }
    
    func getSelectedWeekInterval() {
        
        if selected == 9 {
            self.selectedWeek = "This Week"
            return
        }
        
        let weekLength = 604800.0
        
        if let weekEndTS = userData.weekEndTS {
            
            let lastDayOfWeek = Date(timeIntervalSince1970: weekEndTS - (weekLength * Double(9 - selected)) - 1)
            let firstDayOfWeek = Date(timeIntervalSince1970: weekEndTS - (weekLength * Double(9 - selected + 1)) + 1)
            
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
        StatsView().environmentObject(UserData())
    }
}
