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
                
                if appState.trackingData.workout.rounds[0].sets.count == 0 {
                    Section {
                        selectWorkoutBtn
                    }
                }
                
                WorkoutSpecView(workout: self.$appState.trackingData.workout)
                WorkoutRounds(workout: self.$appState.trackingData.workout, interactor: .init(appState: self.appState, workout: self.$appState.trackingData.workout)).environmentObject(self.appState)
                .onTapGesture {
                    self.viewModel.hideKeyboard()
                }
                Section(header: Text("")) {
                    EmptyView()
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
            .onAppear {
                self.viewModel.startWorkout()
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
    
    private var selectWorkoutBtn: some View {
        Button(action: {
            self.appState.routing.trackWorkout.showWorkoutsModal()
        }, label: {
            Text("Select Workout")
        })
    }
}


// MARK: - Modal Sheet

private extension TrackWorkout {
    @ViewBuilder
    func modalSheet() -> some View {
        if self.appState.routing.trackWorkout.modalView == .workouts {
            PickWorkoutView(trackWorkoutViewModel: self.viewModel).environmentObject(self.appState)
        } else if self.appState.routing.trackWorkout.modalView == .exercises {
            AddExercise(interactor: .init(appState: self.appState, round: self.$appState.trackingData.workout.rounds[self.appState.routing.trackWorkout.curRoundIdx])).environmentObject(self.appState)
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
