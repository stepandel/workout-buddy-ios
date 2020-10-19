//
//  AddNewExercise.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-07.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

class AddNewExerciseViewModel: ObservableObject {
    @Published var exercise: Exercise?
    @Published var wasExerciseSelected = false
}

struct AddNewExercise: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var newWorkoutViewModel: NewWorkoutViewModel
    @ObservedObject var addNewExerciseViewModel: AddNewExerciseViewModel = AddNewExerciseViewModel()
    @State var roundNumber: Int
    
    @State var id = ""
    @State private var repsStr = ""
    @State var reps = 1
    @State private var weightStr = ""
    @State var weight = 1
    @State private var timeStr = ""
    @State var time = 0
    
    @State private var timed = false
    
    @Environment(\.presentationMode) var presentaionMode
    @State private var showingSelectExercises = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentaionMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    if (self.addNewExerciseViewModel.wasExerciseSelected) {
                        self.time = Int(self.timeStr) ?? 0
                        self.reps = Int(self.repsStr) ?? 0
                        self.weight = Int(self.weightStr) ?? 0
                        
                        let newExSet = ExSet(exId: self.addNewExerciseViewModel.exercise!.id, time: self.time, reps: self.reps, weight: self.weight)
                        self.newWorkoutViewModel.workout.rounds[self.roundNumber].sets.append([newExSet])
                        self.presentaionMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Done")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            Form {
                if (addNewExerciseViewModel.wasExerciseSelected) {
                    Text("\(addNewExerciseViewModel.exercise!.id.components(separatedBy: ":")[0].formatFromId())")
                } else {
                    Button(action: { self.showingSelectExercises.toggle() }) {
                        Text("Select Exercise")
                    }
                }
                
                if addNewExerciseViewModel.wasExerciseSelected {
                    HStack {
                        Toggle(isOn: $timed, label: {
                            Text("Timed")
                        })
                    }
                    if timed {
                        HStack {
                            Text("Time (sec): ")
                            TextField("0 sec", text: self.$timeStr).keyboardType(.numberPad)
                        }
                    } else {
                        HStack {
                            Text("Reps: ")
                            TextField("0", text: self.$repsStr).keyboardType(.numberPad)
                        }
                    }
                    HStack {
                        Text("Weight (kg): ")
                        TextField("0 kg", text: self.$weightStr).keyboardType(.numberPad)
                    }
                }
            }
        }.sheet(isPresented: self.$showingSelectExercises) {
            SelectExerciseView(addNewExerciseViewModel: self.addNewExerciseViewModel).environmentObject(self.userData)
        }.onTapGesture {
            self.hideKeyboard()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct AddNewExerciseTracking: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var trackWorkoutViewModel: TrackWorkoutViewModel
    @ObservedObject var addNewExerciseViewModel: AddNewExerciseViewModel = AddNewExerciseViewModel()
    @State var roundNumber: Int
    @State var afterIndex: Int

    @State var id = ""
    @State private var repsStr = ""
    @State var reps = 1
    @State private var weightStr = ""
    @State var weight = 0
    @State private var timeStr = ""
    @State var time = 0
    
    @State private var timed = false

    @Environment(\.presentationMode) var presentaionMode
    @State private var showingSelectExercises = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentaionMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    if (self.addNewExerciseViewModel.wasExerciseSelected) {
                        self.time = Int(self.timeStr) ?? 0
                        self.reps = Int(self.repsStr) ?? 0
                        self.weight = Int(self.weightStr) ?? 0

                        let newExSet = ExSet(exId: self.addNewExerciseViewModel.exercise!.id, time: self.time, reps: self.reps, weight: self.weight)
                        if (self.trackWorkoutViewModel.workout.rounds.isEmpty) {
                            var newRound = Round()
                            newRound.sets = [[newExSet]]
                            self.trackWorkoutViewModel.workout.rounds.append(newRound)
                        }
                        self.trackWorkoutViewModel.workout.rounds[self.roundNumber].sets.insert([newExSet], at: self.afterIndex + 1)
                        
                        self.presentaionMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Done")
                }
            }
            .padding(.horizontal)
            .padding(.top)

            Form {
                if (addNewExerciseViewModel.wasExerciseSelected) {
                    Text("\(addNewExerciseViewModel.exercise!.id.components(separatedBy: ":")[0].formatFromId())")
                } else {
                    Button(action: { self.showingSelectExercises.toggle() }) {
                        Text("Select Exercise")
                    }
                }
                
                if addNewExerciseViewModel.wasExerciseSelected {
                    HStack {
                        Toggle(isOn: $timed, label: {
                            Text("Timed")
                        })
                    }
                    if timed {
                        HStack {
                            Text("Time (sec): ")
                            TextField("0 sec", text: self.$timeStr).keyboardType(.numberPad)
                        }
                    } else {
                        HStack {
                            Text("Reps: ")
                            TextField("0", text: self.$repsStr).keyboardType(.numberPad)
                        }
                    }
                    HStack {
                        Text("Weight (kg): ")
                        TextField("0 kg", text: self.$weightStr).keyboardType(.numberPad)
                    }
                }
            }
        }.sheet(isPresented: self.$showingSelectExercises) {
            SelectExerciseView(addNewExerciseViewModel: self.addNewExerciseViewModel).environmentObject(self.userData)
        }.onTapGesture {
            self.hideKeyboard()
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct AddNewExerciseEdit: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var editWorkoutViewModel: EditWorkoutViewModel
    @ObservedObject var addNewExerciseViewModel = AddNewExerciseViewModel()
    @State var roundNumber: Int
    
    @State var id = ""
    @State private var repsStr = ""
    @State var reps = 1
    @State private var weightStr = ""
    @State var weight = 1
    @State private var timeStr = ""
    @State var time = 0
    
    @State private var timed = false
    
    @Environment(\.presentationMode) var presentaionMode
    @State private var showingSelectExercises = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentaionMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    if (self.addNewExerciseViewModel.wasExerciseSelected) {
                        self.time = Int(self.timeStr) ?? 0
                        self.reps = Int(self.repsStr) ?? 0
                        self.weight = Int(self.weightStr) ?? 0
                        
                        let newExSet = ExSet(exId: self.addNewExerciseViewModel.exercise!.id, time: self.time, reps: self.reps, weight: self.weight)
                        self.editWorkoutViewModel.workout.rounds[self.roundNumber].sets.append([newExSet])
                        self.presentaionMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Done")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            Form {
                if (addNewExerciseViewModel.wasExerciseSelected) {
                    Text("\(addNewExerciseViewModel.exercise!.id.components(separatedBy: ":")[0].formatFromId())")
                } else {
                    Button(action: { self.showingSelectExercises.toggle() }) {
                        Text("Select Exercise")
                    }
                }
                
                if addNewExerciseViewModel.wasExerciseSelected {
                    HStack {
                        Toggle(isOn: $timed, label: {
                            Text("Timed")
                        })
                    }
                    if timed {
                        HStack {
                            Text("Time (sec): ")
                            TextField("0 sec", text: self.$timeStr).keyboardType(.numberPad)
                        }
                    } else {
                        HStack {
                            Text("Reps: ")
                            TextField("0", text: self.$repsStr).keyboardType(.numberPad)
                        }
                    }
                    HStack {
                        Text("Weight (kg): ")
                        TextField("0 kg", text: self.$weightStr).keyboardType(.numberPad)
                    }
                }
            }
        }.sheet(isPresented: self.$showingSelectExercises) {
            SelectExerciseView(addNewExerciseViewModel: self.addNewExerciseViewModel).environmentObject(self.userData)
        }.onTapGesture {
            self.hideKeyboard()
        }
    }
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct AddNewExercise_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddNewExercise(newWorkoutViewModel: NewWorkoutViewModel(), roundNumber: 0).environmentObject(UserData())
            AddNewExerciseTracking(trackWorkoutViewModel: TrackWorkoutViewModel(), roundNumber: 0, afterIndex: 0).environmentObject(UserData())
            AddNewExerciseEdit(editWorkoutViewModel: EditWorkoutViewModel(workout: Workout(name: "Random")), roundNumber: 0)
            .environmentObject(UserData())
        }
    }
}
