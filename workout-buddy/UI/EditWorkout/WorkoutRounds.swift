//
//  WorkoutRoundsView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-21.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct WorkoutRounds: View {
    @EnvironmentObject var appState: AppState
    @Binding var workout: Workout
    @State var curRoundIdx = 0
    @State var showingActionSheet = false
    
    private(set) var interactor: EditWorkoutInteractor
    
    var body: some View {
        ForEach(self.workout.rounds) { round in
            Section(header: Text("Round \(self.workout.rounds.firstIndex(of: round)! + 1)")) {
                self.sets(round: round)
                self.addExerciseBtn(round: round)
            }
            Section {
                self.deleteRoundBtn(round: round)
                self.addRoundBtn(after: round)
            }
            .actionSheet(isPresented: self.$showingActionSheet) {
                self.actionSheet
            }
        }
    }
}


// MARK: - Subviews

extension WorkoutRounds {
    private func sets(round: Round) -> some View {
        return ForEach(round.sets, id: \.self) { set in
            NavigationLink(destination: ExerciseSets(interactor: .init(appState: self.appState, exSets: self.$workout.rounds[self.workout.rounds.firstIndex(of: round)!].sets[round.sets.firstIndex(of: set)!]))) {
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
        .onDelete { self.workout.deleteExercise(at: $0, in: self.workout.rounds.firstIndex(of: round)!) }
        .onMove { self.workout.moveExercise(source: $0, destination: $1, in: self.workout.rounds.firstIndex(of: round)!) }
    }
}


// MARK: - Buttons

extension WorkoutRounds {
    private func addExerciseBtn(round: Round) -> some View {
        Button(action: {
            if let idx = self.workout.rounds.firstIndex(of: round) {
                self.interactor.showExerciseModal(roundIdx: idx)
            }
        }) {
            HStack {
                Spacer()
                Text("+ Exercise")
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }.buttonStyle(BorderlessButtonStyle())
    }
    
    private func deleteRoundBtn(round: Round) -> some View {
        return Button(action: {
            self.workout.deleteRound(round: round)
        }) {
            HStack {
                Spacer()
                Text("Delete round")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                Spacer()
            }
        }.buttonStyle(BorderlessButtonStyle())
    }
    
    private func addRoundBtn(after round: Round) -> some View {
        Button(action: {
            self.curRoundIdx = self.workout.rounds.firstIndex(of: round) ?? 0
            self.showingActionSheet.toggle()
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


// MARK: - ActionSheet

extension WorkoutRounds {
    private var actionSheet: ActionSheet {
        ActionSheet(title: Text("Add Round"), buttons: [
            .default(Text("Empty Round")) {
                self.workout.addRound(after: self.workout.rounds[self.curRoundIdx], copy: false)
            },
            .default(Text("Copy Previous Round")) {
                self.workout.addRound(after: self.workout.rounds[self.curRoundIdx], copy: true)
            },
            .cancel()
        ])
    }
}

struct WorkoutRounds_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRounds(workout: .constant(Workout()), interactor: .init(appState: AppState(), workout: .constant(Workout()), parentView: .edit)).environmentObject(AppState())
    }
}
