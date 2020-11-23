//
//  AddExercise.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-22.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct AddExercise: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State var exId = ""
    @State var timeStr = ""
    @State var repsStr = ""
    @State var weightStr = ""
    @State var timed = false
    
    private(set) var interactor: AddExerciseInteractor
    
    var body: some View {
        VStack {
            HStack {
                self.cancelBtn
                Spacer()
                if self.exId != "" {
                    self.addBtn
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            self.exerciseForm
            
        }.sheet(isPresented: self.$appState.routing.editWorkout.showingSelectExercisesSheet) {
            SelectExerciseView(exId: self.$exId).environmentObject(self.appState)
        }.onTapGesture {
            self.hideKeyboard()
        }
    }
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// MARK: - Buttons

extension AddExercise {
    private var cancelBtn: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
    private var addBtn: some View {
        Button(action: {
            if self.exId != "" {
                self.interactor.addExSet(exId: self.exId, time: self.timeStr, reps: self.repsStr, weight: self.weightStr, timed: self.timed)
            }
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Add")
        }
    }
    
    private var selectExerciseBtn: some View {
        Button(action: {
            self.appState.routing.editWorkout.showSelectExercisesSheet()
        }) {
            if self.exId != "" {
                Text("\(self.exId)")
            } else {
                Text("Select Exercise")
            }
        }.buttonStyle(BorderlessButtonStyle())
    }
}


// MARK: - Subviews

extension AddExercise {
    private var exerciseForm: some View {
        Form {
            self.selectExerciseBtn
            
            if self.exId != "" {
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
    }
}

struct AddExercise_Previews: PreviewProvider {
    static var previews: some View {
        AddExercise(interactor: .init(appState: AppState(), round: .constant(Round()))).environmentObject(AppState())
    }
}
