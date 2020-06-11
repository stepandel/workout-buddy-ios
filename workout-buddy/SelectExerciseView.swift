//
//  SelectExerciseView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-26.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct SelectExerciseView: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var addNewExerciseViewModel: AddNewExerciseViewModel
    @State private var searchText: String = ""
    
    @Environment(\.presentationMode) var presentaionMode
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List {
                    ForEach(userData.exercises.filter {
                        self.searchText.isEmpty ? true : $0.id.contains(self.searchText)
                    }) { exercise in
                        Button(action: {
                            self.addNewExerciseViewModel.exercise = exercise
                            self.addNewExerciseViewModel.wasExerciseSelected.toggle()
                            self.presentaionMode.wrappedValue.dismiss()
                        }) {
                            Text(exercise.id)
                        }
                    }
                }
            }.navigationBarTitle(Text("Exercises"))
        }.onTapGesture {
            self.hideKeyboard()
        }
    }
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SelectExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        SelectExerciseView(addNewExerciseViewModel: AddNewExerciseViewModel()).environmentObject(UserData())
    }
}
