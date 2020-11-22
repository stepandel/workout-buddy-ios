//
//  EditWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-09.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

class EditWorkoutViewModel: ObservableObject { //TODO: - initialize in parent view & pass to EditWorkoutView
    @Published var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
    }
}

struct EditWorkoutView: View {
    @EnvironmentObject var appState: AppState

    @ObservedObject var editWorkoutViewModel: EditWorkoutViewModel
    @State var workoutIdx: Int

    @Environment(\.presentationMode) var presentaionMode

    @State private var workoutName = ""
//    @State private var focus = ""
    @State private var workoutType = ""
    @State private var workoutFocus = ""
    @State private var workoutSets = []
    @State private var exercises: [Exercise] = []
    @State private var roundNumber = 0
    
    @State var showingAddNewExercise = false
    
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {  self.presentaionMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                }
                Spacer()
                Text("\(editWorkoutViewModel.workout.name)")
                Spacer()
                Button(action: {
                    print("workout: \(self.editWorkoutViewModel.workout)")
                                       
//                    self.appState.userData.workouts.append(self.editWorkoutViewModel.workout)
                    self.appState.userData.workouts[self.workoutIdx] = self.editWorkoutViewModel.workout
                    self.appState.saveWorkout(workout: self.editWorkoutViewModel.workout)
                   
                    self.presentaionMode.wrappedValue.dismiss()
                   
                    print("New UserData: \(self.appState.userData.workouts)")
                }) {
                    Text("Done")
                }
            }.padding()
           
            HStack {
                Button(action: { self.addRound(copy: true) }) {
                    Text("Copy Round")
                }.padding(.horizontal)
                Spacer()
                Button(action: { self.addRound(copy: false) }) {
                    Text("Add Round")
                }.padding(.horizontal)
            }.padding(.top)
            
            Form {
                List {
                    TextField("Name", text: self.$editWorkoutViewModel.workout.name)
                    HStack {
                        TextField("Focus", text: self.$editWorkoutViewModel.workout.focus)
                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .accessibility(label: Text("Help"))
                        }
                    }
                    HStack {
                        TextField("Type", text: self.$editWorkoutViewModel.workout.type)
                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .accessibility(label: Text("Help"))
                        }
                    }
                }
                
                ForEach(self.editWorkoutViewModel.workout.rounds.indices) { i in
                    Section(header: Text("Round \(i + 1)"))  {
                        ForEach(self.editWorkoutViewModel.workout.rounds[i].sets, id:\.self) { set in
                            HStack {
                                Text(set[0].exId)
                                Spacer()
                                if set[0].reps! > 0 {
                                    Text("\(set[0].reps!)x")
                                } else if set[0].time != nil {
                                    Text("\(set[0].time!)sec")
                                }
                            }.padding(.horizontal)
                        }.onDelete { (indexSet) in
                            var roundSet = self.editWorkoutViewModel.workout.rounds[i].sets
                            roundSet.remove(atOffsets: indexSet)
                            self.editWorkoutViewModel.workout.rounds[i].sets = roundSet
                        }
                        HStack {
                            Button(action: {
                                self.roundNumber = i
                                self.showingAddNewExercise.toggle()
                            }) {
                                Image(systemName: "plus.circle")
                                .imageScale(.large)
                                .accessibility(label: Text("User Profile"))
                            }.frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }.sheet(isPresented: $showingAddNewExercise) {
            AddNewExerciseEdit(editWorkoutViewModel: self.editWorkoutViewModel, roundNumber: self.roundNumber).environmentObject(self.appState)
        }.onTapGesture {
            self.hideKeyboard()
        }
    }
    
    func addRound(copy: Bool) {
        var newRound = Round()
        if copy {
            newRound.sets = self.editWorkoutViewModel.workout.rounds[0].sets
        }
        print("New Round: \(newRound)")
        
        self.editWorkoutViewModel.workout.rounds.append(newRound)
        
        print("New Workout: \(self.editWorkoutViewModel.workout)")
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct EditWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkoutView(editWorkoutViewModel: EditWorkoutViewModel(workout: Workout(name: "Random")), workoutIdx: 0)
        .environmentObject(AppState())
    }
}
