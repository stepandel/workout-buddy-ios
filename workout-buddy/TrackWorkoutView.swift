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
    @Published var isWorkoutSelected: Bool
    
    init() {
        workout = Workout(name: "")
        isWorkoutSelected = false
    }
}

enum ModalView {
    case workouts
    case exercises
}

enum AlertPopup {
    case endWorkout
    case addRound
}

struct TrackWorkoutView: View {
    @EnvironmentObject var userData: UserData
    
    @Environment(\.presentationMode) var presentaionMode: Binding<PresentationMode>
    
    @ObservedObject var trackWorkoutViewModel = TrackWorkoutViewModel()
    
    @State var showingModalView: Bool
    @State var modalView: ModalView = .workouts
    @State var workoutStarted = false
    @State var currentRound = 0
    @State var curExIdx = 0
    @State var addExAfterIdx = 0
    @State var showingAlert = false
    @State var alertPopup: AlertPopup = .addRound
    @State var startTime: Double = 0
    @State var longShadowRad = 2
    @State var shortShadowRad = 0.5
    @State private var showingActionSheet = false
    
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
            self.showingAlert.toggle()
            self.alertPopup = .endWorkout
        }) {
            Text("Finish")
        }
    }
    
    var btnEnd: some View {
        Button(action: {
            self.showingActionSheet.toggle()
        }) {
            Text("End")
        }
    }
    
    var body: some View {
//        VStack {
                    
//                    HStack {
//                        VStack {
//                            HStack {
//                                Text("Round \(currentRound + 1) of \(trackWorkoutViewModel.workout.rounds.count)")
//                                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
//                                    .padding()
//                                Spacer()
//                            }
//                        }
//
//                    }
                    
                    // Exercise List broken down by Round
//        NavigationView {
        List {
            Section {
                TextField("New Workout", text: self.$trackWorkoutViewModel.workout.name)
            }
            ForEach(self.trackWorkoutViewModel.workout.rounds) { round in
                Section(header: Text("Round \(self.trackWorkoutViewModel.workout.rounds.firstIndex(of: round)! + 1)")) {
                    ForEach(round.sets, id: \.self) { set in
                        NavigationLink(destination: SelectedExerciseView(trackWorkoutViewModel: self.trackWorkoutViewModel, currentRound: self.trackWorkoutViewModel.workout.rounds.firstIndex(of: round)!, curExIdx: round.sets.firstIndex(of: set)!)) {
                        HStack {
                            VStack {
                                Text("\(set[0].exId.components(separatedBy: ":")[0].formatFromId())")
                                Spacer()
                                Text("\(set.count) \(set.count > 1 ? "Sets" : "Set")")
                                .font(.footnote)
                                if (set[0].completed ?? false) {
                                    Text("Completed")
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                } else if (set[0].skipped ?? false) {
                                    Text("Skipped")
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            Spacer()
                            if set[0].reps! > 0 {
                                Text("\(set[0].reps!)x")
                            } else if set[0].time != nil {
                                Text("\(set[0].time!)sec")
                            }
                        }
                    }
//                    .onTapGesture {
////                                        self.trackWorkoutViewModel.currentExercise = exercise
//                        self.currentRound = self.trackWorkoutViewModel.workout.rounds.firstIndex(of: round)!
//                        self.curExIdx = round.sets.firstIndex(of: set) ?? 0
//                    }
                    
                    }
                    .onDelete { self.deleteExercise(at: $0, in: self.trackWorkoutViewModel.workout.rounds.firstIndex(of: round)!) }
                    .onMove { self.moveExercise(source: $0, destination: $1, in: self.trackWorkoutViewModel.workout.rounds.firstIndex(of: round)!) }
                    
                    Button(action: { self.addExercise(round: self.trackWorkoutViewModel.workout.rounds.firstIndex(of: round)!, addLast: true) }) {
                        Text("+ Exercise")
                            .multilineTextAlignment(.center)
                    }
                        
                }
                Section {
                    Button(action: {
                        self.deleteRound(round: self.trackWorkoutViewModel.workout.rounds.firstIndex(of: round)!)
                    }) {
                        Text("Delete round")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                    }
                    Button(action: {
                        self.currentRound = self.trackWorkoutViewModel.workout.rounds.firstIndex(of: round)!
                        self.curExIdx = 0
                        self.showingAlert.toggle()
                        self.alertPopup = .addRound
                    }) {
                        Text("Add Round")
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .onTapGesture {
                self.hideKeyboard()
            }
            Section(header: Text("")) {
                EmptyView()

            }
        }
        .listStyle(GroupedListStyle())
//        }
        .onAppear {
            print("\(self.trackWorkoutViewModel.workout)")
            UIApplication.shared.isIdleTimerDisabled = true
            startWorkout()
        }
        .sheet(isPresented: $showingModalView, onDismiss: {
            self.showingModalView = false
        }, content: {
            if self.modalView == .workouts {
                PickWorkoutView(workouts: self.userData.workouts, trackWorkoutViewModel: self.trackWorkoutViewModel)
            } else if self.modalView == .exercises {
                AddNewExerciseTracking(trackWorkoutViewModel: self.trackWorkoutViewModel, roundNumber: self.currentRound, afterIndex: self.addExAfterIdx).environmentObject(self.userData)
            }
        })
        .alert(isPresented: $showingAlert) {
            if self.alertPopup == .endWorkout {
                return Alert(title: Text("Cancel Workout"), message: Text("Are you sure you want to cancel workout?"), primaryButton: .default(Text("Yes!"), action: {
                    self.cancelWorkout()
                }), secondaryButton: .default(Text("No")))
            } else if self.alertPopup == .addRound {
                return Alert(title: Text("Add Round"), message: Text("Do you want to copy round?"), primaryButton: .default(Text("Yes"), action: {
                    self.addRound(copyRound: true)
                }), secondaryButton: .default(Text("No, create empty round"), action: { self.addRound(copyRound: false)}))
            } else {
                return Alert(title: Text("Something went wrong!"))
            }
        }
        .actionSheet(isPresented: $showingActionSheet, content: {
            ActionSheet(title: Text("End Workout?"), buttons: [
                .default(Text("Finish Workout")) {
                    self.completeWorkout()
                },
                .default(Text("Cancel Workout").foregroundColor(.red)) {
                    self.showingAlert.toggle()
                    self.alertPopup = .endWorkout
                },
                .cancel()
            ])
        })
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
//        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnEnd, trailing: EditButton())
        .navigationBarTitle(self.trackWorkoutViewModel.workout.name)
        
    }
    
    func completeExercise(at offsets: IndexSet) {
        if (!self.workoutStarted) { self.startWorkout() }
        
        // Start new round
        if (self.curExIdx + 1 >= self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets.count) {
            print("Rounds \(self.trackWorkoutViewModel.workout.rounds)")
            
            // Continue to the next round
            if (self.currentRound + 1 < self.trackWorkoutViewModel.workout.rounds.count) { // Check if next round is avaiable
                
                self.currentRound += 1
                self.curExIdx = 0
            }
            
        } else { // Continue to the next exercise in the round
            self.curExIdx += 1
        }
    }
    
    func addExercise(round: Int, addLast: Bool) {
        self.currentRound = round
        self.addExAfterIdx = addLast ? self.trackWorkoutViewModel.workout.rounds[round].sets.count - 1 : self.curExIdx
        self.modalView = .exercises
        self.showingModalView.toggle()
    }
    
    func skipExercise(at offset: IndexSet, in round: Int) {
        offset.forEach { i in
            self.trackWorkoutViewModel.workout.rounds[round].sets[i][0].skipped = true
            self.trackWorkoutViewModel.workout.rounds[round].sets[i][0].completed = false
        }
    }
    
    func deleteExercise(at offset: IndexSet, in round: Int) {
        self.trackWorkoutViewModel.workout.rounds[round].sets.remove(atOffsets: offset)
    }
    
    func moveExercise(source: IndexSet, destination: Int, in round: Int) {
        self.trackWorkoutViewModel.workout.rounds[round].sets.move(fromOffsets: source, toOffset: destination)
    }
    
    func addRound(copyRound: Bool) {
        var newRound = Round()
        if copyRound {
            newRound.sets = self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets
        }
        self.trackWorkoutViewModel.workout.rounds.insert(newRound, at: self.currentRound + 1)
        self.currentRound += 1
        self.curExIdx = 0
    }
    
    func deleteRound(round: Int) {
        self.trackWorkoutViewModel.workout.rounds.remove(at: round)
        if self.trackWorkoutViewModel.workout.rounds.count == 0 {
            // Add new empty round
            let newRound = Round()
            self.trackWorkoutViewModel.workout.rounds.append(newRound)
        }
        
        self.currentRound = self.currentRound == 0 ? self.currentRound : self.currentRound - 1
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
        let completedWorkout = CompletedWorkout(workout: self.trackWorkoutViewModel.workout, startTS: self.startTime, time: workoutTime)
        print("Completed workout: \(completedWorkout)")
        self.userData.saveCompletedWorkout(completedWorkout: completedWorkout)
        
        // Reset workout data
        self.workoutStarted = false
        self.trackWorkoutViewModel.workout = Workout(name: "")
        self.trackWorkoutViewModel.isWorkoutSelected = false
//        self.trackWorkoutViewModel.currentExercise = nil
    }
    
    func cancelWorkout() {
        print("Workout cancelled")
        
        // Reset workout data
        self.workoutStarted = false
        self.trackWorkoutViewModel.workout = Workout(name: "")
        self.trackWorkoutViewModel.isWorkoutSelected = false
        self.currentRound = 0
        self.curExIdx = 0
        
        self.presentaionMode.wrappedValue.dismiss()
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TrackWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        TrackWorkoutView(showingModalView: false).environmentObject(UserData())
    }
}
