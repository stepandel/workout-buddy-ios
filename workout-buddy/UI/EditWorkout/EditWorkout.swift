//
//  EditCompletedWorkout.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-21.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct EditWorkout: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State var workout: Workout
    
    private(set) var interactor: EditWorkoutInteractor
    
    var body: some View {
        NavigationView {
            List {
                WorkoutSpecView(workout: self.$workout)
                WorkoutRounds(workout: self.$workout, interactor: self.interactor).environmentObject(self.appState)
                .onTapGesture {
                    self.hideKeyboard()
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(self.workout.name)
            .navigationBarItems(leading: cancelBtn, trailing: saveBtn)
        }
        .sheet(isPresented: self.$appState.routing.editWorkout.showingModalSheet) {
            AddExercise(interactor: .init(appState: self.appState, round: self.$workout.rounds[self.appState.routing.editWorkout.curRoundIdx])).environmentObject(self.appState)
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// MARK: - Buttons

extension EditWorkout {
    private var cancelBtn: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }

    }
    
    private var saveBtn: some View {
        Button {
            self.interactor.saveWorkout(workout: self.workout)
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Save")
        }

    }
}


// MARK: - Routing

extension EditWorkout {
    struct Routing {
        var showingModalSheet = false
        private(set) var curRoundIdx = 0
        var showingSelectExercisesSheet = false
        
        mutating func showExercisesModal(roundIdx: Int) {
            self.curRoundIdx = roundIdx
            self.showingModalSheet = true
        }
        
        mutating func showSelectExercisesSheet() {
            self.showingSelectExercisesSheet = true
        }
        
        mutating func dismissSelectExercisesSheet() {
            self.showingSelectExercisesSheet = false
        }
    }
}

struct EditWorkout_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkout(workout: Workout(), interactor: .init(appState: AppState(), workout: .constant(Workout()))).environmentObject(AppState())
    }
}
