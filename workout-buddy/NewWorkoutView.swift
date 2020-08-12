//
//  NewWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-13.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

class NewWorkoutViewModel: ObservableObject {
    @Published var workout: Workout = Workout(name: "New Workout")
}

struct NewWorkoutView: View {
    @EnvironmentObject var userData: UserData
    
    @ObservedObject var newWorkoutViewModel = NewWorkoutViewModel()
    
    @Environment(\.presentationMode) var presentaionMode
    
    @State private var workoutName = ""
//    @State private var focus = ""
    @State private var workoutType = ""
    @State private var workoutFocus = ""
    @State private var workoutSets = []
    @State private var exercises: [Exercise] = []
    @State private var roundNumber = 0
    
//    @State var isFocused = false
    @State var showingAddNewExercise = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentaionMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                Spacer()
                Text("NEW WORKOUT")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    
                    print("workout: \(self.newWorkoutViewModel.workout)")
                    
                    self.userData.workouts.append(self.newWorkoutViewModel.workout)
                    
                    self.presentaionMode.wrappedValue.dismiss()
                    
                    print("New UserData: \(self.userData.workouts)")
                    
                    // Save to remote DB
                    self.userData.saveWorkout(workout: self.newWorkoutViewModel.workout)
                    
                }) {
                    Text("Done")
                }
            }.padding()
            
            Section {
                HStack {
                    Button(action: {
                        self.addRound(copy: true)
                    }) {
                        Text("Copy Round")
                    }.padding(.horizontal)
                    Spacer()
                    Button(action: {
                        self.addRound(copy: false)
                    }) {
                        Text("Add Round")
                    }.padding(.horizontal)
                }
            }.padding(.top)
            
            Form {
                List {
                    TextField("Name", text: self.$newWorkoutViewModel.workout.name)
//                        .onTapGesture {
//                            self.isFocused = true
//                    }
                    HStack {
                        TextField("Type", text: self.$newWorkoutViewModel.workout.type)
//                            .onTapGesture {
//                                self.isFocused = true
//                        }
                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .accessibility(label: Text("Help"))
                        }
                    }
                    HStack {
                        TextField("Focus", text: self.$newWorkoutViewModel.workout.focus)
//                            .onTapGesture {
//                                self.isFocused = true
//                        }
                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .accessibility(label: Text("Help"))
                        }
                    }
                }
                ForEach(self.newWorkoutViewModel.workout.rounds, id:\.self) { round in
                    Section(header: Text("Round \(round.id + 1)")){
                        
                        List(round.sets, id:\.exId) { set in
                            HStack {
                                Text(set.exId)
                                Spacer()
                                if set.reps! > 0 {
                                    Text("\(set.reps!)x")
                                } else if set.time != nil {
                                    Text("\(set.time!)sec")
                                }
                            }.padding(.horizontal)
                        }
                        HStack {
                            Button(action: {
                                self.roundNumber = self.newWorkoutViewModel.workout.rounds.firstIndex(of: round)!
                                print("Round number: \(self.roundNumber)")
                                self.showingAddNewExercise.toggle()
                                print("Workout: \(self.newWorkoutViewModel.workout)")
                            }) {
                                Image(systemName: "plus.circle")
                                    .imageScale(.large)
                                    .accessibility(label: Text("User Profile"))
                            }.frame(maxWidth: .infinity)
                        }
                        
                    }
                }
            }.sheet(isPresented: $showingAddNewExercise) {
                AddNewExercise(newWorkoutViewModel: self.newWorkoutViewModel, roundNumber: self.roundNumber).environmentObject(self.userData)
            }.onTapGesture {
//                self.isFocused = false
                self.hideKeyboard()
            }
        }
        
        // TODO: - Add navigation title
        // TODO: - Add cancel & done navigation bar buttons
    }
    
    func addRound(copy: Bool) {
        
        let numberOfRounds = self.newWorkoutViewModel.workout.rounds.count
        var newRound = Round(id: numberOfRounds)
        if copy {
            newRound.sets = self.newWorkoutViewModel.workout.rounds[0].sets ?? []
        }
        print("New Round: \(newRound)")
        
        self.newWorkoutViewModel.workout.rounds.append(newRound)
        
        print("New Workout Model: \(self.newWorkoutViewModel)")
//        self.newWorkoutViewModel.workout.sets = self.newWorkoutViewModel.workout.sets.map({ (exSet) -> ExSet in
//            var newSet = exSet
//            newSet.sets += 1
//            return newSet
//        })
    }
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct NewWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkoutView().environmentObject(UserData())
    }
}
