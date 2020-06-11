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
    @EnvironmentObject var userData: UserData

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
                                       
//                    self.userData.workouts.append(self.editWorkoutViewModel.workout)
                    self.userData.workouts[self.workoutIdx] = self.editWorkoutViewModel.workout
                    self.userData.saveWorkout(workout: self.editWorkoutViewModel.workout)
                   
                    self.presentaionMode.wrappedValue.dismiss()
                   
                    print("New UserData: \(self.userData.workouts)")
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
                        TextField("Focus", text: self.$editWorkoutViewModel.workout.focus.bound)
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
                
                ForEach(self.editWorkoutViewModel.workout.rounds ?? [Round(id: 0)], id:\.self) { round in
                    Section(header: Text("Round \(round.id + 1)"))  {
                        ForEach(round.sets ?? [], id:\.exId) { set in
                            HStack {
                                Text(set.exId)
                                Spacer()
                                if set.reps! > 0 {
                                    Text("\(set.reps!)x")
                                } else if set.time != nil {
                                    Text("\(set.time!)sec")
                                }
                            }.padding(.horizontal)
                        }.onDelete { (indexSet) in
                            if let round = self.editWorkoutViewModel.workout.rounds?.firstIndex(of: round) {
                                var roundSet = self.editWorkoutViewModel.workout.rounds![round].sets ?? []
                                roundSet.remove(atOffsets: indexSet)
                                self.editWorkoutViewModel.workout.rounds![round].sets = roundSet
                            }
                        }
                        HStack {
                            Button(action: {
                                if let rounds = self.editWorkoutViewModel.workout.rounds {
                                    self.roundNumber = rounds.firstIndex(of: round)!
                                } else {
                                    self.addRound(copy: false)
                                    self.roundNumber = 0
                                }
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
            AddNewExerciseEdit(editWorkoutViewModel: self.editWorkoutViewModel, roundNumber: self.roundNumber).environmentObject(self.userData)
        }.onTapGesture {
            self.hideKeyboard()
        }
    }
    
    func addRound(copy: Bool) {
        let numberOfRounds = self.editWorkoutViewModel.workout.rounds?.count ?? 0
        var newRound = Round(id: numberOfRounds)
        if copy {
            newRound.sets = self.editWorkoutViewModel.workout.rounds?[0].sets ?? []
        }
        print("New Round: \(newRound)")
        
        if self.editWorkoutViewModel.workout.rounds == nil {
            self.editWorkoutViewModel.workout.rounds = []
        }
        self.editWorkoutViewModel.workout.rounds?.append(newRound)
        
        print("New Workout: \(self.editWorkoutViewModel.workout)")
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct EditWorkout_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkoutView(editWorkoutViewModel: EditWorkoutViewModel(workout: Workout(name: "Random", sets: [])), workoutIdx: 0)
        .environmentObject(UserData())
    }
}
