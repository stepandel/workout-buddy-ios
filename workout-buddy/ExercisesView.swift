//
//  ExercisesView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-21.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ExercisesView: View {
    @EnvironmentObject var userData: UserData
    @State private var searchText: String = ""
    @State var isPresented = false
    
    var body: some View {
        NavigationView {
            if userData.exercises.count > 0 {
                VStack {
                    SearchBar(text: $searchText)
                    List {
                        ForEach(userData.exercises.filter {
                            self.searchText.isEmpty ? true : $0.id.contains(self.searchText)
                        }) { exercise in
                            Text("\(exercise.id.components(separatedBy: ":")[0].formatFromId())")
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationBarTitle("My Exercises")
                    .navigationBarItems(trailing: Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image(systemName: "plus")
                    })
                }
            } else {
                Text("Create New Exercise")
                    .onTapGesture {
                        self.isPresented.toggle()
                    }
                    .navigationBarTitle("My Exercises")
                    .navigationBarItems(trailing: Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image(systemName: "plus")
                    })
            }
        }
        .sheet(isPresented: self.$isPresented) { NewExerciseView().environmentObject(self.userData) }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView().environmentObject(UserData())
    }
}
