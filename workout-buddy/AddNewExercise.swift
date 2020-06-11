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
    @State private var setsStr = ""
    @State var sets = 1
    @State private var timeStr = ""
    @State var time = 0
    
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
                        print("Round number: \(self.roundNumber)")
                        print("Time: \(self.timeStr)")
                        self.time = Int(self.timeStr) ?? 0
                        self.reps = Int(self.repsStr) ?? 0
                        self.sets = Int(self.setsStr) ?? 0
                        
                        let newExSet = ExSet(exId: self.addNewExerciseViewModel.exercise!.id, time: self.time, reps: self.reps, sets: self.sets)
                        print("New Set: \(newExSet)")
                        self.newWorkoutViewModel.workout.sets.append(newExSet)
                        print("Round: \(self.newWorkoutViewModel.workout.rounds?[self.roundNumber])")
                        self.newWorkoutViewModel.workout.rounds?[self.roundNumber].sets?.append(newExSet)
                        print("Round: \(self.newWorkoutViewModel.workout.rounds?[self.roundNumber])")
                        self.presentaionMode.wrappedValue.dismiss()
                        print("\(self.newWorkoutViewModel.workout)")
                    }
                }) {
                    Text("Done")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            Form {
                if (addNewExerciseViewModel.wasExerciseSelected) {
                    Text("\(addNewExerciseViewModel.exercise!.id)")
                } else {
                    Button(action: { self.showingSelectExercises.toggle() }) {
                        Text("Select Exercise")
                    }
                }
//                TextField("Id", text: $id)
                HStack {
                    Text("Reps: ")
                    TextField("Reps", text: self.$repsStr).keyboardType(.numberPad)
                }
                HStack {
                    Text("Sets: ")
                    TextField("Sets", text: self.$setsStr).keyboardType(.numberPad)
                }
                HStack {
                    Text("Time: ")
                    TextField("Time", text: self.$timeStr).keyboardType(.numberPad)
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
        AddNewExercise(newWorkoutViewModel: NewWorkoutViewModel(), roundNumber: 0).environmentObject(UserData())
    }
}
