//
//  TrackWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-12.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

class TrackWorkoutViewModel: ObservableObject {
    @Published var workout: Workout = Workout(name: "", sets: [])
    @Published var rounds: [Round] = []
    @Published var exercises: [ExSet] = []
    @Published var isWorkoutSelected = false
    @Published var currentExercise: ExSet?
}

struct TrackWorkoutView: View {
    @EnvironmentObject var userData: UserData
    
    @ObservedObject var trackWorkoutViewModel = TrackWorkoutViewModel()
    
    @State var showingWorkoutPicker = true
    @State var workoutStarted = false
    @State var currentRound = 1
    @State var showingEndWorkoutAlert = false
    @State var showingToStopAlert = false
    @State var startTime: Double = 0
    
    var body: some View {
        VStack {
            if (trackWorkoutViewModel.isWorkoutSelected) {
                VStack {
                    Spacer(minLength: 32)
                    HStack {
                        Button(action: {
                            self.cancelWorkout()
                        }) {
                            Text("Cancel")
                                .foregroundColor(.red)
                        }.padding(.leading)
                        Spacer()
                    }
                    Spacer(minLength: 64)
                    HStack {
                        StopWatchView()
                    }
                    if (self.trackWorkoutViewModel.currentExercise != nil) {
                        VStack {
                            Button(action: {
                                if let exIdx = self.trackWorkoutViewModel.exercises.firstIndex(of: self.trackWorkoutViewModel.currentExercise!) {
                                    let indexSet = IndexSet.init(integer: exIdx)
                                    self.completeExercise(at: indexSet)
                                }
                            }) {
                                Text("\(self.trackWorkoutViewModel.currentExercise!.exId.components(separatedBy: ":")[0].formatId())")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                    .frame(width: 240, height: 40)
                                    .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                            }
                            .padding(.init(top: 0, leading: 0, bottom: 32, trailing: 0))
                            
                            HStack {
                                Button(action: {
                                    if let exIdx = self.trackWorkoutViewModel.exercises.firstIndex(of: self.trackWorkoutViewModel.currentExercise!) {
                                        if self.trackWorkoutViewModel.currentExercise!.reps! > 0 {
                                            self.trackWorkoutViewModel.exercises[exIdx].reps! -= 1
                                            self.trackWorkoutViewModel.currentExercise!.reps! -= 1
                                        } else if self.trackWorkoutViewModel.currentExercise!.time != nil {
                                            self.trackWorkoutViewModel.exercises[exIdx].time! -= 1
                                            self.trackWorkoutViewModel.currentExercise!.time! -= 1
                                        }
                                    }
                                }) {
                                    Image(systemName: "minus")
                                        .frame(width: 60, height: 60)
                                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                                }.padding(.trailing)
                                if self.trackWorkoutViewModel.currentExercise!.reps! > 0 {
                                    Text("\(self.trackWorkoutViewModel.currentExercise!.reps!)x")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                        .frame(width: 60, height: 40)
                                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                                        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                                } else if self.trackWorkoutViewModel.currentExercise!.time != nil {
                                    Text("\(self.trackWorkoutViewModel.currentExercise!.time!)sec")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                        .frame(width: 60, height: 40)
                                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                                        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                                }
                                Button(action: {
                                    if let exIdx = self.trackWorkoutViewModel.exercises.firstIndex(of: self.trackWorkoutViewModel.currentExercise!) {
                                        if self.trackWorkoutViewModel.currentExercise!.reps! > 0 {
                                            self.trackWorkoutViewModel.exercises[exIdx].reps! += 1
                                            self.trackWorkoutViewModel.currentExercise!.reps! += 1
                                        } else if self.trackWorkoutViewModel.currentExercise!.time != nil {
                                            self.trackWorkoutViewModel.exercises[exIdx].time! += 1
                                            self.trackWorkoutViewModel.currentExercise!.time! += 1
                                        }
                                    }
                                }) {
                                    Image(systemName: "plus")
                                        .frame(width: 60, height: 60)
                                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                                }.padding(.leading)
                            }
                        }
                        .padding(.init(top: 32, leading: 32, bottom: 16, trailing: 32))
                    }
                    HStack {
                        VStack {
                            HStack {
                                Text("\(self.trackWorkoutViewModel.workout.name)")
                                    .font(.title)
                                    .padding()
                                Spacer()
                            }
                            HStack {
                                Text("Round \(currentRound)")
                                    .padding()
                                Spacer()
                            }
                        }
                        
                    }
                    List {
                        ForEach(self.trackWorkoutViewModel.exercises, id:\.exId) { exercise in
                            HStack {
                                Text("\(exercise.exId)")
                                Spacer()
                                if exercise.reps! > 0 {
                                    Text("\(exercise.reps!)x")
                                } else if exercise.time != nil {
                                    Text("\(exercise.time!)sec")
                                }
                            }
                        }.onDelete(perform: completeExercise)
                    }
//                    .listStyle(GroupedListStyle())
                }
                .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
            } else {
                Button(action: { self.showingWorkoutPicker.toggle() }) {
                    Text("Select Workout")
                }
            }
        }
        .onAppear {
            print("\(self.trackWorkoutViewModel.workout)")
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .sheet(isPresented: $showingWorkoutPicker) {
            PickWorkoutView(workouts: self.userData.workouts, trackWorkoutViewModel: self.trackWorkoutViewModel)
        }
        .alert(isPresented: $showingEndWorkoutAlert) {
            if (self.showingToStopAlert) {
                return Alert(title: Text("Stop Workout"), message: Text("Are you sure you want to end workout?"), primaryButton: .default(Text("Yes, I'm done!"), action: {
                    self.completeWorkout()
                }), secondaryButton: .cancel())
            } else {
                return Alert(title: Text("Workout Complete"), message: Text("Finish now?"), dismissButton: .default(Text("Yes"), action: {
                    self.completeWorkout()
                }))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
    }
    
    func completeExercise(at offsets: IndexSet) {
        self.trackWorkoutViewModel.exercises.remove(atOffsets: offsets)
        
        if (!self.workoutStarted) { self.startWorkout() }
        
        if (self.trackWorkoutViewModel.exercises.count == 0) {
            print("Rounds \(self.trackWorkoutViewModel.rounds)")
            // Select the next ex set
//            if let rounds = self.trackWorkoutViewModel.rounds {
                if (self.trackWorkoutViewModel.rounds.count != 0) {
                    print("Rounds: \(self.trackWorkoutViewModel.rounds)")
                    self.trackWorkoutViewModel.exercises = self.trackWorkoutViewModel.rounds[0].sets ?? []
                    self.currentRound = self.trackWorkoutViewModel.rounds[0].id + 1
                    self.trackWorkoutViewModel.rounds.removeFirst()
                    self.trackWorkoutViewModel.currentExercise = self.trackWorkoutViewModel.exercises[0]
                } else {
                    // prompt to finish workout
                    print("End workout alert!")
                    self.showingEndWorkoutAlert.toggle()
                }
//            } else {
//                // prompt to finish workout
//                self.showingEndWorkoutAlert.toggle()
//            }
        } else {
            self.trackWorkoutViewModel.currentExercise = self.trackWorkoutViewModel.exercises[0]
        }
        print(self.trackWorkoutViewModel.currentExercise)
    }
    
    func startWorkout() {
        self.workoutStarted = true
        
        // Start timer
        print("Timer: \(Date().timeIntervalSince1970)")
        self.startTime = Date().timeIntervalSince1970
    }
    
    func completeWorkout() {
        print("Workout complete")
        
        // Stop timer
        let currentTime = Date().timeIntervalSince1970
        let workoutTime = Int(round(currentTime - self.startTime))
        
        // Save workout to log
        let completedWorkout = CompletedWorkout(workout: self.trackWorkoutViewModel.workout, completionTs: Date().timeIntervalSince1970, time: workoutTime)
        print("Completed workout: \(completedWorkout)")
        self.userData.workoutLog.append(completedWorkout)
        self.userData.saveCompletedWorkout(completedWorkout: completedWorkout)
        
        // Reset workout data
        self.workoutStarted = false
        self.trackWorkoutViewModel.workout = Workout(name: "", sets: [])
        self.trackWorkoutViewModel.rounds = []
        self.trackWorkoutViewModel.exercises = []
        self.trackWorkoutViewModel.isWorkoutSelected = false
    }
    
    func cancelWorkout() {
        print("Workout cancelled")
        
        // Reset workout data
        self.workoutStarted = false
        self.trackWorkoutViewModel.workout = Workout(name: "", sets: [])
        self.trackWorkoutViewModel.rounds = []
        self.trackWorkoutViewModel.exercises = []
        self.trackWorkoutViewModel.isWorkoutSelected = false
    }
}

struct TrackWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        TrackWorkoutView().environmentObject(UserData())
    }
}
