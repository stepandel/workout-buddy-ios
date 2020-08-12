//
//  TrackWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-12.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

class TrackWorkoutViewModel: ObservableObject {
    @Published var workout: Workout
    @Published var rounds: [Round]
    @Published var exercises: [ExSet]
    @Published var isWorkoutSelected: Bool
    @Published var currentExercise: ExSet?
    @Published var numOfRounds: Int
    @Published var completedWorkout: Workout
    
    init() {
        workout = Workout(name: "")
        rounds = []
        exercises = []
        isWorkoutSelected = false
        numOfRounds = 0
        completedWorkout = Workout(name: "")
    }
}

enum ModalView {
    case workouts
    case exercises
}

struct TrackWorkoutView: View {
    @EnvironmentObject var userData: UserData
    
    @Environment(\.presentationMode) var presentaionMode: Binding<PresentationMode>
    
    @ObservedObject var trackWorkoutViewModel = TrackWorkoutViewModel()
    
    @State var showingModalView: Bool
    @State var modalView: ModalView = .workouts
    @State var workoutStarted = false
    @State var currentRound = 1
    @State var showingEndWorkoutAlert = false
    @State var showingToStopAlert = false
    @State var startTime: Double = 0
    
    var btnCancel: some View {
        Button(action: {
            self.cancelWorkout()
        }) {
            Text("Cancel")
            .foregroundColor(.red)
        }
    }
    
    var btnFinish: some View {
        Button(action: {
            self.showingEndWorkoutAlert.toggle()
        }) {
            Text("Finish")
        }
    }
    
    var body: some View {
        VStack {
                VStack {
                    Spacer(minLength: 160)
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
                    } else {
                        VStack {
                            Button(action: {
                                self.modalView = .exercises
                                self.showingModalView.toggle()
                            }) {
                                Image(systemName: "plus")
                                        .frame(width: 60, height: 60)
                                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                            }.padding(.bottom)
                            Button(action: {
                                //TODO: - Add Round
                            }) {
                                Text("Add Round")
                                        .frame(width: 120, height: 60)
                                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                                }
                        }
//                        .padding(.init(top: 32, leading: 32, bottom: 16, trailing: 32))
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
                                Text("Round \(currentRound) of \(trackWorkoutViewModel.numOfRounds)")
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
        }
        .onAppear {
            print("\(self.trackWorkoutViewModel.workout)")
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .sheet(isPresented: $showingModalView, onDismiss: {
            self.showingModalView = false
        }, content: {
            if self.modalView == .workouts {
                PickWorkoutView(workouts: self.userData.workouts, trackWorkoutViewModel: self.trackWorkoutViewModel)
            } else if self.modalView == .exercises {
                 AddNewExerciseTracking(trackWorkoutViewModel: self.trackWorkoutViewModel, roundNumber: self.currentRound - 1).environmentObject(self.userData)
            }
        })
        .alert(isPresented: $showingEndWorkoutAlert) {
            return Alert(title: Text("Stop Workout"), message: Text("Are you sure you want to end workout?"), primaryButton: .default(Text("Yes, I'm done!"), action: {
                self.completeWorkout()
            }), secondaryButton: .cancel())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnCancel, trailing: btnFinish)
    }
    
    func completeExercise(at offsets: IndexSet) {
        self.trackWorkoutViewModel.exercises.remove(atOffsets: offsets)
        
        // Save completed exercise
        if (!self.trackWorkoutViewModel.completedWorkout.rounds.indices.contains(currentRound - 1)) {
            let newRound = Round(id: currentRound - 1)
            self.trackWorkoutViewModel.completedWorkout.rounds.append(newRound)
        }
        if let currentExercise = self.trackWorkoutViewModel.currentExercise {
            self.trackWorkoutViewModel.completedWorkout.rounds[currentRound - 1].sets.append(currentExercise)
        }
        
        
        if (!self.workoutStarted) { self.startWorkout() }
        
        if (self.trackWorkoutViewModel.exercises.count == 0) {
            print("Rounds \(self.trackWorkoutViewModel.rounds)")
            
            self.trackWorkoutViewModel.rounds.removeFirst()
            
                // Continue to the next round
                if (self.trackWorkoutViewModel.rounds.count != 0) {
                    
                    self.trackWorkoutViewModel.rounds.forEach { (round) in
                        print("Round: \(round.id)")
                    }
                    
                    self.trackWorkoutViewModel.exercises = self.trackWorkoutViewModel.rounds[0].sets ?? []
                    self.currentRound = self.trackWorkoutViewModel.rounds[0].id + 1
                    self.trackWorkoutViewModel.currentExercise = self.trackWorkoutViewModel.exercises[0]
                } else {
                  
                    // Reset current exercise
                    self.trackWorkoutViewModel.currentExercise = nil
                }
            
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
        let completedWorkout = CompletedWorkout(workout: self.trackWorkoutViewModel.completedWorkout, completionTs: Date().timeIntervalSince1970, time: workoutTime)
        print("Completed workout: \(completedWorkout)")
        self.userData.workoutLog.append(completedWorkout)
        self.userData.saveCompletedWorkout(completedWorkout: completedWorkout)
        
        // Reset workout data
        self.workoutStarted = false
        self.trackWorkoutViewModel.workout = Workout(name: "")
        self.trackWorkoutViewModel.rounds = []
        self.trackWorkoutViewModel.exercises = []
        self.trackWorkoutViewModel.isWorkoutSelected = false
        self.trackWorkoutViewModel.currentExercise = nil
        self.trackWorkoutViewModel.numOfRounds = 0
        self.trackWorkoutViewModel.completedWorkout = self.trackWorkoutViewModel.workout
    }
    
    func cancelWorkout() {
        print("Workout cancelled")
        
        // Reset workout data
        self.workoutStarted = false
        self.trackWorkoutViewModel.workout = Workout(name: "")
        self.trackWorkoutViewModel.rounds = []
        self.trackWorkoutViewModel.exercises = []
        self.trackWorkoutViewModel.isWorkoutSelected = false
        
        self.presentaionMode.wrappedValue.dismiss()
    }
}

struct TrackWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        TrackWorkoutView(showingModalView: false).environmentObject(UserData())
    }
}
