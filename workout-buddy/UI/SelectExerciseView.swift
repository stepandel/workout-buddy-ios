//
//  SelectExerciseView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-26.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct SelectExerciseView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var addNewExerciseViewModel: AddNewExerciseViewModel
    @State private var searchText: String = ""
    @State private var isPresented = false
    
    @Environment(\.presentationMode) var presentaionMode
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List {
                    ForEach(appState.userData.exercises.filter {
                        self.searchText.isEmpty ? true : $0.id.contains(self.searchText)
                    }) { exercise in
                        Button(action: {
                            self.addNewExerciseViewModel.exercise = exercise
                            self.addNewExerciseViewModel.wasExerciseSelected = true
                            self.presentaionMode.wrappedValue.dismiss()
                        }) {
                            Text(exercise.id.components(separatedBy: ":")[0].formatFromId())
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }
            }.navigationBarTitle(Text("Exercises"))
            // TODO: - fix bug. Crashing when creating new exercise
//            .navigationBarItems(trailing: Button(action: {
//                self.isPresented.toggle()
//            }) {
//                Text("+ New Exercise")
//            })
        }.sheet(isPresented: self.$isPresented) { NewExerciseView().environmentObject(self.appState) }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SelectExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        SelectExerciseView(addNewExerciseViewModel: AddNewExerciseViewModel()).environmentObject(AppState())
    }
}
