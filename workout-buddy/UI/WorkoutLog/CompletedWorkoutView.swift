//
//  CompletedWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-19.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct CompletedWorkoutView: View {
    @EnvironmentObject var appState: AppState
    @Binding var completedWorkout: CompletedWorkout
    
    @State var dateStr = ""
    @State var isEditPresented = false
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        List {
            
            Section {
                HStack {
                    Text("Date: \(dateStr)")
                        .padding()
                    Spacer()
                }
                
                if completedWorkout.workout.focus != "" {
                    HStack {
                        Text("Focus: \(completedWorkout.workout.focus)")
                        Spacer()
                    }.padding()
                }
                    
                HStack {
                    Text("Rounds: \(completedWorkout.workout.rounds.count)x")
                    Spacer()
                }
                .padding()
                
                if completedWorkout.workout.notes != "" {
                    VStack {
                        HStack {
                            Text("Notes:")
                            Spacer()
                        }.padding([.leading, .top])
                        Text(completedWorkout.workout.notes)
                            .frame(minHeight: 100)
                    }.padding(.bottom, 32)
                }
            }
            
            RoundBlock(rounds: completedWorkout.workout.rounds)
            
            Spacer()
        }
        .sheet(isPresented: self.$isEditPresented, content: {
            EditWorkout(workout: self.completedWorkout.workout, interactor: .init(appState: self.appState, workout: self.$completedWorkout.workout, parentView: .edit)).environmentObject(self.appState)
        })
        .onAppear {
            self.dateFormatter.timeZone = TimeZone.current
            self.dateFormatter.locale = NSLocale.current
            self.dateFormatter.dateFormat = "MMM-d, yyyy"
            
            let date = Date(timeIntervalSince1970: self.completedWorkout.startTS)
            self.dateStr = self.dateFormatter.string(from: date)
        }.navigationBarTitle(Text("\(completedWorkout.workout.name)"))
        .navigationBarItems(trailing: Button(action: {
            self.isEditPresented.toggle()
        }, label: {
            Text("Edit")
        }))
    }
}

struct CompletedWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedWorkoutView(completedWorkout: .constant(sampleWorkoutLog[0])).environmentObject(AppState())
    }
}
