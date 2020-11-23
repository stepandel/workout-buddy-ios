//
//  Exercises.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-23.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct Exercises: View {
    @EnvironmentObject var appState: AppState
    @State private var onlyMyExercises = false
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Toggle(isOn: self.$onlyMyExercises) {
                Text("Only Show My Exercises")
            }.padding()
            SearchBar(text: self.$searchText)
            if self.onlyMyExercises {
                if self.appState.userData.exercises.count > 0 {
                    self.myExerciesList
                } else {
                    self.createNewExerciseTxtBtn
                }
            } else {
                if self.appState.userData.allExercises.count > 0 {
                    self.allExercisesList
                } else {
                    self.createNewExerciseTxtBtn
                }
            }
        }
        .navigationBarTitle("Exercises")
        .navigationBarItems(trailing: Button(action: {
            self.appState.routing.exrecises.presentNewExerciseModal()
        }) {
            Text("+ New Exercise")
        })
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}


// MARK: - Subviews

extension Exercises {
    private var myExerciesList: some View {
        List {
            ForEach(appState.userData.exercises.filter {
                self.searchText.isEmpty ? true : $0.id.contains(self.searchText)
            }) { exercise in
                Text("\(exercise.id.components(separatedBy: ":")[0].formatFromId())")
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var allExercisesList: some View {
        List {
            ForEach(appState.userData.allExercises.filter {
                self.searchText.isEmpty ? true : $0.id.contains(self.searchText)
            }) { exercise in
                Text("\(exercise.id.components(separatedBy: ":")[0].formatFromId())")
            }
        }
        .listStyle(PlainListStyle())
    }
}


// MARK: - Buttons

extension Exercises {
    private var createNewExerciseTxtBtn: some View {
        Text("Create New Exercise")
        .onTapGesture {
            self.appState.routing.exrecises.presentNewExerciseModal()
        }
    }
}


// MARK: - Appearance

extension Exercises {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// MARK: - Routing

extension Exercises {
    struct Routing {
        var isModalSheetPresented = false
        
        mutating func presentNewExerciseModal() {
            self.isModalSheetPresented = true
        }
    }
}



struct Exercises_Previews: PreviewProvider {
    static var previews: some View {
        Exercises().environmentObject(AppState())
    }
}
