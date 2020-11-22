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

struct EditWorkout_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkout(workout: Workout(), interactor: .init(appState: AppState(), workout: .constant(Workout()))).environmentObject(AppState())
    }
}
