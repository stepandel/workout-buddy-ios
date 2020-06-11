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
}

struct TrackWorkoutView: View {
    @EnvironmentObject var userData: UserData
    
    @ObservedObject var trackWorkoutViewModel = TrackWorkoutViewModel()
    
    @State var showingWorkoutPicker = false
    @State var workoutStarted = false
    @State var currentRound = 1
    @State var showingEndWorkoutAlert = false
    @State var showingToStopAlert = false
    @State var startTime: Double = 0
    
    var body: some View {
        VStack {
            if (trackWorkoutViewModel.isWorkoutSelected) {
                VStack {
                    HStack {
                        Button(action: {
                            self.cancelWorkout()
                        }) {
                            Text("Cancel")
                                .foregroundColor(.red)
                        }.padding(.leading)
                        Spacer()
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
                                Text("Focus: \(self.trackWorkoutViewModel.workout.focus ?? "")")
                                    .padding()
                                Spacer()
                            }
                            HStack {
                                Text("Round \(currentRound)")
                                    .padding()
                                Spacer()
                            }
                        }
                        Button(action: {
                            if (!self.workoutStarted) {
                                self.startWorkout()
                            } else {
                                self.showingToStopAlert.toggle()
                                self.showingEndWorkoutAlert.toggle()
                            }
                        }) {
                            if(self.workoutStarted) {
                                Image(systemName: "stop.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                    .imageScale(.large)
                                    .padding()
                            } else {
                                Image(systemName: "play.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                    .imageScale(.large)
                                    .padding()
                            }
                        }.padding(32)
                        
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
                        }.onDelete(perform: delete)
                    }
                }
            } else {
                Button(action: { self.showingWorkoutPicker.toggle() }) {
                    Text("Select Workout")
                }
            }
        }
        .onAppear {
            print("\(self.trackWorkoutViewModel.workout)")
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
    }
    
    func delete(at offsets: IndexSet) {
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
                } else {
                    // prompt to finish workout
                    print("End workout alert!")
                    self.showingEndWorkoutAlert.toggle()
                }
//            } else {
//                // prompt to finish workout
//                self.showingEndWorkoutAlert.toggle()
//            }
        }
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
