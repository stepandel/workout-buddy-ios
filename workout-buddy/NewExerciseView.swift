//
//  NewExerciseView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-22.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct NewExerciseView: View {
    @EnvironmentObject var userData: UserData
    
    @State var name = ""
    @State var equipment = ""
    @State var type = ""
    @State var bodyPart = ""
    @State var muscleGroup = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) { Text("Cancel") }
                Spacer()
                Button(action: {
                    
                    let exId = self.name.formatToId() + ":" + self.equipment.formatToId() + ":" + self.type.formatToId()
                    let newExercise = Exercise(id: exId, bodyPart: self.bodyPart, muscleGroup: self.muscleGroup)
                    
                    self.userData.exercises.append(newExercise)
                    
                    self.userData.saveExercise(exercise: newExercise)
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) { Text("Done") }
            }.padding(.horizontal)
                .padding(.top)
            Form {
                List {
                    TextField("Name", text: $name)
                    TextField("Equipment", text: $equipment)
                    TextField("Type", text: $type)
                    TextField("Body Part", text: $bodyPart)
                    TextField("Muscle Group", text: $muscleGroup)
                }
            }
        }.onTapGesture {
            self.hideKeyboard()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct NewExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NewExerciseView().environmentObject(UserData())
    }
}
