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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: Activities.ViewModel
    @State var workoutLogIdx: Int
    @State var weekIdx: Int
    
    @State var dateStr = ""
    @State var isEditPresented = false
    @State var isShowingAlert = false
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        
        if self.appState.userData.workoutLog.indices.contains(workoutLogIdx) {
        
            self.workoutView(completedWorkout: self.appState.userData.workoutLog[workoutLogIdx])
            .sheet(isPresented: self.$isEditPresented, content: {
                EditWorkout(workout: self.appState.userData.workoutLog[workoutLogIdx].workout, interactor: .init(appState: self.appState, workout: self.$appState.userData.workoutLog[self.workoutLogIdx].workout, parentView: .edit)).environmentObject(self.appState)
            })
            .onAppear {
                self.dateFormatter.timeZone = TimeZone.current
                self.dateFormatter.locale = NSLocale.current
                self.dateFormatter.dateFormat = "MMM-d, yyyy"
                
                let date = Date(timeIntervalSince1970: self.appState.userData.workoutLog[workoutLogIdx].startTS)
                self.dateStr = self.dateFormatter.string(from: date)
            }.navigationBarTitle(Text("\(self.appState.userData.workoutLog[workoutLogIdx].workout.name)"))
            .navigationBarItems(trailing: trailingBarItemStack)
            .alert(isPresented: self.$isShowingAlert) {
                self.alert()
            }
            
        } else {
            EmptyView() // When the workout is being deleted
        }
    }
}


// MARK: - Buttons

extension CompletedWorkoutView {
    private var editButton: some View {
        Button(action: {
            self.isEditPresented.toggle()
        }, label: {
            Text("Edit")
        })
    }
    
    private var deleteButton: some View {
        Button(action: {
            self.isShowingAlert.toggle()
        }, label: {
            Image(systemName: "trash")
        })
    }
    
    private var trailingBarItemStack: some View {
        HStack {
            deleteButton
                .padding(.trailing)
            editButton
        }
    }
}


// MARK: - Alerts

extension CompletedWorkoutView {
    private func alert() -> Alert {
        return Alert(title: Text("Are you sure you want to delete this workout?"), primaryButton: .default(Text("Yes"), action: {
            self.presentationMode.wrappedValue.dismiss()
            self.viewModel.deleteWorkout(completedWorkout: self.appState.userData.workoutLog[workoutLogIdx], weekIdx: weekIdx)
        }), secondaryButton: .default(Text("No")))
    }
}


// MARK: - Subviews

extension CompletedWorkoutView {
    private func workoutView(completedWorkout: CompletedWorkout) -> some View {
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
    }
}

struct CompletedWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedWorkoutView(viewModel: .init(appState: AppState()), workoutLogIdx: 0, weekIdx: 0).environmentObject(AppState())
    }
}
