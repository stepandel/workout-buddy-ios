//
//  TrackWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-12.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct TrackWorkout: View {
    @EnvironmentObject var userData: UserData
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
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
                self.viewModel.startWorkout()
            }
            .sheet(isPresented: $viewModel.showingModalView) {
                modalSheet()
            }
            .alert(isPresented: $viewModel.showingAlert) {
               alert()
            }
            .actionSheet(isPresented: $viewModel.showingActionSheet) {
                actionSheet()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnEnd, trailing: EditButton())
            .navigationBarTitle(self.viewModel.workout.name)
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
            self.viewModel.showingAlert.toggle()
        }) {
            Text("Finish")
        }
    }
    
    private var btnEnd: some View {
        Button(action: {
            self.viewModel.showingActionSheet.toggle()
            self.viewModel.actionSheetView = .endWorkout
        }) {
            Text("End")
        }
    }
}


// MARK: - Content

private extension TrackWorkout {
    var workoutSpecView: some View {
        Section {
            TextField("New Workout", text: self.$viewModel.workout.name)
            HStack {
                Text("Focus: ")
                Spacer()
                TextField("Focus", text: self.$viewModel.workout.focus)
            }
            if #available(iOS 14.0, *) {
                VStack(alignment: .leading) {
                    Text("Notes: ")
                    TextEditor(text: self.$viewModel.workout.notes)
                        .frame(minHeight: 100)
                }
            }
        }
    }
    
    var workoutRoundsView: some View {
        ForEach(self.viewModel.workout.rounds) { round in
            Section(header: Text("Round \(self.viewModel.workout.rounds.firstIndex(of: round)! + 1)")) {
                ForEach(round.sets, id: \.self) { set in
                    NavigationLink(destination: SelectedExerciseView(trackWorkoutViewModel: self.viewModel, currentRound: self.viewModel.workout.rounds.firstIndex(of: round)!, curExIdx: round.sets.firstIndex(of: set)!)) {
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
                .onDelete { self.viewModel.deleteExercise(at: $0, in: self.viewModel.workout.rounds.firstIndex(of: round)!) }
                .onMove { self.viewModel.moveExercise(source: $0, destination: $1, in: self.viewModel.workout.rounds.firstIndex(of: round)!) }
                
                Button(action: { self.viewModel.addExercise(round: self.viewModel.workout.rounds.firstIndex(of: round)!, addLast: true) }) {
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
                    self.viewModel.deleteRound(round: self.viewModel.workout.rounds.firstIndex(of: round)!)
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
                    self.viewModel.currentRound = self.viewModel.workout.rounds.firstIndex(of: round)!
                    self.viewModel.curExIdx = 0
                    self.viewModel.showingActionSheet.toggle()
                    self.viewModel.actionSheetView = .addRound
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
        if self.viewModel.modalView == .workouts {
            PickWorkoutView(trackWorkoutViewModel: self.viewModel).environmentObject(self.userData)
        } else if self.viewModel.modalView == .exercises {
            AddNewExerciseTracking(trackWorkoutViewModel: self.viewModel, roundNumber: self.viewModel.currentRound, afterIndex: self.viewModel.addExAfterIdx).environmentObject(self.userData)
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
        if self.viewModel.actionSheetView == .endWorkout {
            return ActionSheet(title: Text("End Workout?"), buttons: [
                .default(Text("Finish Workout")) {
                    self.viewModel.completeWorkout()
                },
                .default(Text("Cancel Workout").foregroundColor(.red)) {
                    self.viewModel.showingAlert.toggle()
                },
                .cancel()
            ])
        } else if self.viewModel.actionSheetView == .addRound {
            return ActionSheet(title: Text("Add Round"), buttons: [
                .default(Text("Empty Round")) {
                    self.viewModel.addRound(copyRound: false)
                },
                .default(Text("Copy Previous Round")) {
                    self.viewModel.addRound(copyRound: true)
                },
                .cancel()
            ])
        } else {
            return ActionSheet(title: Text("Something went wrong!"), buttons: [ .cancel() ])
        }
    }
}


// MARK: - Preview

struct TrackWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        TrackWorkout(viewModel: .init(userData: UserData(), showingModalView: false)).environmentObject(UserData())
    }
}
