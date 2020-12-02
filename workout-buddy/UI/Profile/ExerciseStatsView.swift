//
//  ExerciseStatsView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-25.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ExerciseStatsView: View {
    @EnvironmentObject var appState: AppState
    @State var exId: String
    @State var exerciseStats: ExerciseStats
    @State var tenWeekRollingExerciseStats: TenWeekRollingExerciseStats
    @State var selected = 9
    @State var selectedWeek = "This Week"
    
    var body: some View {
        List {
            self.totalsSection
            if !tenWeekRollingExerciseStats.isAllZero(param: .volume) {
                self.volumeGraph
            }
            if !tenWeekRollingExerciseStats.isAllZero(param: .maxWeight) {
                self.maxWeightGraph
            }
            if !tenWeekRollingExerciseStats.isAllZero(param: .oneRM) {
                self.oneRMGraph
            }
            if !tenWeekRollingExerciseStats.isAllZero(param: .totalReps) {
                self.repsGraph
            }
            if !tenWeekRollingExerciseStats.isAllZero(param: .maxReps) {
                self.maxRepsGraph
            }
            if !tenWeekRollingExerciseStats.isAllZero(param: .totalTime) {
                self.timeGraph
            }
            if !tenWeekRollingExerciseStats.isAllZero(param: .maxTime) {
                self.maxTimeGraph
            }
            if !tenWeekRollingExerciseStats.isAllZero(param: .totalSets) {
                self.setsGraph
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(Text("\(exId.components(separatedBy: ":")[0].formatFromId())"))
    }
}


// MARK: - Subviews

extension ExerciseStatsView {
    var totalsSection: some View {
        Section(header: Text("Totals")) {
            if exerciseStats.volume > 0 {
                HStack {
                    Text("Volume (kg): ")
                    Spacer()
                    Text("\(exerciseStats.volume)")
                }
            }
            if exerciseStats.maxWeight > 0 {
                HStack {
                    Text("Max Weight (kg): ")
                    Spacer()
                    Text("\(exerciseStats.maxWeight)")
                }
            }
            if exerciseStats.oneRM > 0 {
                HStack {
                    Text("1 RM (kg): ")
                    Spacer()
                    Text("\(exerciseStats.oneRM)")
                }
            }
            if exerciseStats.totalReps > 0 {
                HStack {
                    Text("Total Reps: ")
                    Spacer()
                    Text("\(exerciseStats.totalReps)")
                }
            }
            if exerciseStats.maxReps > 0 {
                HStack {
                    Text("Max Reps: ")
                    Spacer()
                    Text("\(exerciseStats.maxReps)")
                }
            }
            if exerciseStats.totalTime > 0 {
                HStack {
                    Text("Total Time (s): ")
                    Spacer()
                    Text("\(exerciseStats.totalTime)")
                }
            }
            if exerciseStats.maxTime > 0 {
                HStack {
                    Text("Max Time (s): ")
                    Spacer()
                    Text("\(exerciseStats.maxTime)")
                }
            }
            if exerciseStats.totalSets > 0 {
                HStack {
                    Text("Total Sets: ")
                    Spacer()
                    Text("\(exerciseStats.totalSets)")
                }
            }
        }
    }
}


// MARK: - Modifiers

extension ExerciseStatsView {
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


// MARK: - Graphs

extension ExerciseStatsView {
    private var volumeGraph: some View {
        Section(header: Text("Volume (kg) (" + selectedWeek + ")")) {
            HStack(spacing: 16) {
                ForEach(self.tenWeekRollingExerciseStats.weeklyStats.indices, id: \.self) { idx in
                    VStack {
                        
                        Spacer(minLength: 0)
                        
                        if selected == idx {
                            Text("\(self.tenWeekRollingExerciseStats.weeklyStats[idx].stats.volume)")
                                .font(.footnote)
                                .padding(.bottom, 5)
                        }
                        
                        Rectangle()
                            .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                            .frame(height: self.tenWeekRollingExerciseStats.normilized(by: .volume)[idx] * 200)
                    }
                    .frame(height: 220)
                    .onTapGesture {
                        selected = idx
                        getSelectedWeekInterval()
                    }
                }
            }.listRowBackground(Constants.Colors.appBackground)
        }
    }
    
    private var maxWeightGraph: some View {
        Section(header: Text("Max Weight (kg) (" + selectedWeek + ")")) {
            HStack(spacing: 16) {
                ForEach(self.tenWeekRollingExerciseStats.weeklyStats.indices, id: \.self) { idx in
                    VStack {
                        
                        Spacer(minLength: 0)
                        
                        if selected == idx {
                            Text("\(self.tenWeekRollingExerciseStats.weeklyStats[idx].stats.maxWeight)")
                                .font(.footnote)
                                .padding(.bottom, 5)
                        }
                        
                        Rectangle()
                            .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                            .frame(height: self.tenWeekRollingExerciseStats.normilized(by: .maxWeight)[idx] * 200)
                    }
                    .frame(height: 220)
                    .onTapGesture {
                        selected = idx
                        getSelectedWeekInterval()
                    }
                }
            }.listRowBackground(Constants.Colors.appBackground)
            
        }
    }
    
    private var oneRMGraph: some View {
        Section(header: Text("One Rep Max (kg) (" + selectedWeek + ")")) {
            HStack(spacing: 16) {
                ForEach(self.tenWeekRollingExerciseStats.weeklyStats.indices, id: \.self) { idx in
                    VStack {
                        
                        Spacer(minLength: 0)
                        
                        if selected == idx {
                            Text("\(self.tenWeekRollingExerciseStats.weeklyStats[idx].stats.oneRM)")
                                .font(.footnote)
                                .padding(.bottom, 5)
                        }
                        
                        Rectangle()
                            .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                            .frame(height: self.tenWeekRollingExerciseStats.normilized(by: .oneRM)[idx] * 200)
                    }
                    .frame(height: 220)
                    .onTapGesture {
                        selected = idx
                        getSelectedWeekInterval()
                    }
                }
            }.listRowBackground(Constants.Colors.appBackground)
            
        }
    }
    
    private var repsGraph: some View {
        Section(header: Text("Total Reps (" + selectedWeek + ")")) {
            HStack(spacing: 16) {
                ForEach(self.tenWeekRollingExerciseStats.weeklyStats.indices, id: \.self) { idx in
                    VStack {
                        
                        Spacer(minLength: 0)
                        
                        if selected == idx {
                            Text("\(self.tenWeekRollingExerciseStats.weeklyStats[idx].stats.totalReps)")
                                .font(.footnote)
                                .padding(.bottom, 5)
                        }
                        
                        Rectangle()
                            .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                            .frame(height: self.tenWeekRollingExerciseStats.normilized(by: .totalReps)[idx] * 200)
                    }
                    .frame(height: 220)
                    .onTapGesture {
                        selected = idx
                        getSelectedWeekInterval()
                    }
                }
            }.listRowBackground(Constants.Colors.appBackground)
        }
    }
    
    private var maxRepsGraph: some View {
        Section(header: Text("Max Reps (" + selectedWeek + ")")) {
            HStack(spacing: 16) {
                ForEach(self.tenWeekRollingExerciseStats.weeklyStats.indices, id: \.self) { idx in
                    VStack {
                        
                        Spacer(minLength: 0)
                        
                        if selected == idx {
                            Text("\(self.tenWeekRollingExerciseStats.weeklyStats[idx].stats.maxReps)")
                                .font(.footnote)
                                .padding(.bottom, 5)
                        }
                        
                        Rectangle()
                            .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                            .frame(height: self.tenWeekRollingExerciseStats.normilized(by: .maxReps)[idx] * 200)
                    }
                    .frame(height: 220)
                    .onTapGesture {
                        selected = idx
                        getSelectedWeekInterval()
                    }
                }
            }.listRowBackground(Constants.Colors.appBackground)
        }
    }
    
    private var timeGraph: some View {
        Section(header: Text("Total Time (s) (" + selectedWeek + ")")) {
            HStack(spacing: 16) {
                ForEach(self.tenWeekRollingExerciseStats.weeklyStats.indices, id: \.self) { idx in
                    VStack {
                        
                        Spacer(minLength: 0)
                        
                        if selected == idx {
                            Text("\(self.tenWeekRollingExerciseStats.weeklyStats[idx].stats.totalTime)")
                                .font(.footnote)
                                .padding(.bottom, 5)
                        }
                        
                        Rectangle()
                            .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                            .frame(height: self.tenWeekRollingExerciseStats.normilized(by: .totalTime)[idx] * 200)
                    }
                    .frame(height: 220)
                    .onTapGesture {
                        selected = idx
                        getSelectedWeekInterval()
                    }
                }
            }.listRowBackground(Constants.Colors.appBackground)
        }
    }
    
    private var maxTimeGraph: some View {
        Section(header: Text("Max Time (s) (" + selectedWeek + ")")) {
            HStack(spacing: 16) {
                ForEach(self.tenWeekRollingExerciseStats.weeklyStats.indices, id: \.self) { idx in
                    VStack {
                        
                        Spacer(minLength: 0)
                        
                        if selected == idx {
                            Text("\(self.tenWeekRollingExerciseStats.weeklyStats[idx].stats.maxTime)")
                                .font(.footnote)
                                .padding(.bottom, 5)
                        }
                        
                        Rectangle()
                            .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                            .frame(height: self.tenWeekRollingExerciseStats.normilized(by: .maxTime)[idx] * 200)
                    }
                    .frame(height: 220)
                    .onTapGesture {
                        selected = idx
                        getSelectedWeekInterval()
                    }
                }
            }.listRowBackground(Constants.Colors.appBackground)
        }
    }
    
    private var setsGraph: some View {
        Section(header: Text("Total Sets (" + selectedWeek + ")")) {
            HStack(spacing: 16) {
                ForEach(self.tenWeekRollingExerciseStats.weeklyStats.indices, id: \.self) { idx in
                    VStack {
                        
                        Spacer(minLength: 0)
                        
                        if selected == idx {
                            Text("\(self.tenWeekRollingExerciseStats.weeklyStats[idx].stats.totalSets)")
                                .font(.footnote)
                                .padding(.bottom, 5)
                        }
                        
                        Rectangle()
                            .fill(selected == idx ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.4))
                            .frame(height: self.tenWeekRollingExerciseStats.normilized(by: .totalSets)[idx] * 200)
                    }
                    .frame(height: 220)
                    .onTapGesture {
                        selected = idx
                        getSelectedWeekInterval()
                    }
                }
            }.listRowBackground(Constants.Colors.appBackground)
        }
    }
}

struct ExerciseStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseStatsView(exId: "", exerciseStats: ExerciseStats(), tenWeekRollingExerciseStats: TenWeekRollingExerciseStats()).environmentObject(AppState())
    }
}
