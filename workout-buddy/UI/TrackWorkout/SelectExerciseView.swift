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
    @Binding var exId: String
    @State private var searchText: String = ""
    @State private var isPresented = false
    @State private var onlyMyExercises = false
    
    @Environment(\.presentationMode) var presentaionMode
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle(isOn: $onlyMyExercises) {
                    Text("Show Only My Exercises")
                }.padding()
                SearchBar(text: $searchText)
                if onlyMyExercises {
                    List {
                        ForEach(appState.userData.exercises.filter {
                            self.searchText.isEmpty ? true : $0.id.contains(self.searchText)
                        }) { exercise in
                            Button(action: {
                                self.exId = exercise.id
                                self.presentaionMode.wrappedValue.dismiss()
                            }) {
                                Text(exercise.id.components(separatedBy: ":")[0].formatFromId())
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                    }
                } else {
                    List {
                        ForEach(appState.userData.allExercises.filter {
                            self.searchText.isEmpty ? true : $0.id.contains(self.searchText)
                        }) { exercise in
                            Button(action: {
                                self.exId = exercise.id
                                self.presentaionMode.wrappedValue.dismiss()
                            }) {
                                Text(exercise.id.components(separatedBy: ":")[0].formatFromId())
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }.navigationBarTitle(Text("Exercises"))
            .navigationBarItems(trailing: Button(action: {
                self.isPresented.toggle()
            }) {
                Text("+ New Exercise")
            })
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
        SelectExerciseView(exId: .constant("")).environmentObject(AppState())
    }
}
