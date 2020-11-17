//
//  NewExerciseView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-22.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct NewExerciseView: View {
    @EnvironmentObject var appState: AppState
    
    @State var name = ""
    @State var equipment = ""
    @State var type = "pow"
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
                    
                    self.appState.userData.exercises.append(newExercise)
                    
                    self.appState.userData.saveExercise(exercise: newExercise)
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) { Text("Done") }
            }.padding(.horizontal)
                .padding(.top)
            Form {
                List {
                    HStack {
                        Text("Name: ")
                        Spacer()
                        TextField("Name", text: $name)
                    }
                    HStack {
                        Text("Equipment: ")
                        Spacer()
                        TextField("Equipment", text: $equipment)
                    }
                    if #available(iOS 14.0, *) {
                        HStack {
                            Text("Type: ")
                            
                            Spacer()
                            
                            Menu {
                                Button(action: { self.type = "pow"}) {
                                    Text("Power")
                                }
                                Button(action: { self.type = "exp" }) {
                                    Text("Explosive")
                                }
                                Button(action: { self.type = "iso" }) {
                                    Text("Isometric")
                                }
                            } label: {
                                Text("\(self.type)")
                            }
                        }
                    } else {
                        // Fallback on earlier versions
                        HStack {
                            Text("Type: ")
                            Spacer()
                            TextField("Type", text: $type)
                        }
                    }
                    HStack {
                        Text("Body Part: ")
                        Spacer()
                        TextField("Body Part", text: $bodyPart)
                    }
                    HStack {
                        Text("Muscle Group: ")
                        Spacer()
                        TextField("Muscle Group", text: $muscleGroup)
                    }
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
        NewExerciseView().environmentObject(AppState())
    }
}
