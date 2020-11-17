//
//  TrackWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-12.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct TrackWorkout: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject private(set) var viewModel: ViewModel
    @Environment(\.presentationMode) var presentaionMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            List {
                workoutSpecView
                workoutRoundsView
                .onTapGesture {
                    self.viewModel.hideKeyboard()
                }
                Section(header: Text("")) {
                    EmptyView()
                }
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                    if !self.appState.trackingData.workoutStarted {
                        self.appState.routing.trackWorkout.showStartWorkoutActionSheet()
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .sheet(isPresented: $appState.routing.trackWorkout.showingModalView) {
                modalSheet()
            }
            .alert(isPresented: $appState.routing.trackWorkout.showingAlert) {
               alert()
            }
            .actionSheet(isPresented: $appState.routing.trackWorkout.showingActionSheet) {
                actionSheet()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnEnd, trailing: EditButton())
            .navigationBarTitle(self.appState.trackingData.workout.name)
        }
    }
}


// MARK: - Buttons

private extension TrackWorkout {
    private var btnCancel: some View {
        Button(action: {
            self.viewModel.cancelWorkout()
            self.presentaionMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
            .foregroundColor(.red)
        }
    }
    
    private var btnFinish: some View {
        Button(action: {
            
        }) {
            Text("Finish")
        }
    }
    
    private var btnEnd: some View {
        Button(action: {
            self.appState.routing.trackWorkout.showEndWorkoutActionSheet()
        }) {
            Text("End")
        }
    }
}


// MARK: - Content

private extension TrackWorkout {
    var workoutSpecView: some View {
        Section {
            TextField("New Workout", text: self.$appState.trackingData.workout.name)
            HStack {
                Text("Focus: ")
                Spacer()
                TextField("Focus", text: self.$appState.trackingData.workout.focus)
            }
            if #available(iOS 14.0, *) {
                VStack(alignment: .leading) {
                    Text("Notes: ")
                    TextEditor(text: self.$appState.trackingData.workout.notes)
                        .frame(minHeight: 100)
                }
            }
        }
    }
    
    var workoutRoundsView: some View {
        ForEach(self.appState.trackingData.workout.rounds) { round in
            Section(header: Text("Round \(self.appState.trackingData.workout.rounds.firstIndex(of: round)! + 1)")) {
                ForEach(round.sets, id: \.self) { set in
                    NavigationLink(destination: SelectedExerciseView(currentRound: self.appState.trackingData.workout.rounds.firstIndex(of: round)!, curExIdx: round.sets.firstIndex(of: set)!).environmentObject(self.appState)) {
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
                
                }
                .onDelete { self.viewModel.deleteExercise(at: $0, in: self.appState.trackingData.workout.rounds.firstIndex(of: round)!) }
                .onMove { self.viewModel.moveExercise(source: $0, destination: $1, in: self.appState.trackingData.workout.rounds.firstIndex(of: round)!) }
                
                Button(action: { self.viewModel.addExercise(round: self.appState.trackingData.workout.rounds.firstIndex(of: round)!, addLast: true) }) {
                    HStack {
                        Spacer()
                        Text("+ Exercise")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }.buttonStyle(BorderlessButtonStyle())
                    
            }
            Section {
                Button(action: {
                    self.viewModel.deleteRound(round: self.appState.trackingData.workout.rounds.firstIndex(of: round)!)
                }) {
                    HStack {
                        Spacer()
                        Text("Delete round")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                        Spacer()
                    }
                }.buttonStyle(BorderlessButtonStyle())
                Button(action: {
                    self.appState.trackingData.currentRound = self.appState.trackingData.workout.rounds.firstIndex(of: round)!
                    self.appState.trackingData.curExIdx = 0
                    self.appState.routing.trackWorkout.showAddRoundActionSheet()
                }) {
                    HStack {
                        Spacer()
                        Text("Add Round")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }.buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}


// MARK: - Modal Sheet

private extension TrackWorkout {
    @ViewBuilder
    func modalSheet() -> some View {
        if self.appState.routing.trackWorkout.modalView == .workouts {
            PickWorkoutView(trackWorkoutViewModel: self.viewModel).environmentObject(self.appState)
        } else if self.appState.routing.trackWorkout.modalView == .exercises {
            AddNewExerciseTracking(roundNumber: self.appState.trackingData.currentRound, afterIndex: self.appState.trackingData.addExAfterIdx).environmentObject(self.appState)
        }
    }
}


// MARK: - Alert

private extension TrackWorkout {
    func alert() -> Alert {
        Alert(title: Text("Cancel Workout"), message: Text("Are you sure you want to cancel workout?"), primaryButton: .default(Text("Yes!"), action: {
            self.viewModel.cancelWorkout()
        }), secondaryButton: .default(Text("No")))
    }
}


// MARK: - Action Sheet

private extension TrackWorkout  {
    func actionSheet() -> ActionSheet {
        if self.appState.routing.trackWorkout.actionSheetView == .endWorkout {
            return ActionSheet(title: Text("End Workout?"), buttons: [
                .default(Text("Finish Workout")) {
                    self.viewModel.completeWorkout()
                },
                .default(Text("Cancel Workout").foregroundColor(.red)) {
                    self.appState.routing.trackWorkout.showCancelWorkoutAlert()
                },
                .cancel()
            ])
        } else if self.appState.routing.trackWorkout.actionSheetView == .addRound {
            return ActionSheet(title: Text("Add Round"), buttons: [
                .default(Text("Empty Round")) {
                    self.viewModel.addRound(copyRound: false)
                },
                .default(Text("Copy Previous Round")) {
                    self.viewModel.addRound(copyRound: true)
                },
                .cancel()
            ])
        } else if self.appState.routing.trackWorkout.actionSheetView == .startWorkout {
            return ActionSheet(title: Text("Start Workout"), buttons: [
                .default(Text("Start New")) {
                    self.viewModel.startWorkout()
                },
                .default(Text("Select")) {
                    self.viewModel.startWorkout()
                    self.appState.routing.trackWorkout.showWorkoutsModal()
                },
                .cancel() {
                    self.appState.routing.contentView.routeToActivities()
                }
            ])
        } else {
            return ActionSheet(title: Text("Something went wrong!"), buttons: [ .cancel() ])
        }
    }
}


// MARK: - Preview

struct TrackWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        TrackWorkout(viewModel: .init(appState: AppState())).environmentObject(AppState())
    }
}
