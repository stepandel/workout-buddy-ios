//
//  SelectedExerciseView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-04.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct SetData: Hashable, Identifiable {
    var id: UUID
    var exId: String
    var reps: String
    var time: String
    var weight: String
    
    init(exId: String, reps: String, time: String, weight: String) {
        self.id = UUID()
        self.exId = exId
        self.reps = reps
        self.time = time
        self.weight = weight
    }
}

struct SelectedExerciseView: View {
    @ObservedObject var trackWorkoutViewModel: TrackWorkoutViewModel
    @State var currentRound: Int
    @State var curExIdx: Int
    
    @State private var reps: String = "0"
    @State private var time: String = "0"
    @State private var weight: String = "0"
    @State private var sets: [SetData] = []
    @State private var timed = false
    
    var body: some View {
        List {
            HStack {
                Text("Set #")
                Spacer()
                Text("Weight (kg)")
                Spacer()
                if timed {
                    Text("Time (sec)")
                } else {
                    Text("Reps")
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            ForEach(self.sets) { set in
                HStack {
                    Text("\(self.sets.firstIndex(of: set)! + 1)")
                    Spacer()
                    TextField("0 kg", text: self.$sets[self.sets.firstIndex(of: set)!].weight)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .frame(width: 80, height: 40)
                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                    Spacer()
                    if timed {
                        TextField("0 sec", text: self.$sets[self.sets.firstIndex(of: set)!].time)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .frame(width: 80, height: 40)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                            .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                    } else {
                        TextField("0", text: self.$sets[self.sets.firstIndex(of: set)!].reps)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .frame(width: 80, height: 40)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                            .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            .onDelete { (offset) in
                self.sets.remove(atOffsets: offset)
            }
            Button(action: {
                self.addSet()
            }) {
                Text("+ Set")
            }
        }
        .onAppear {
            self.sets = self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx].reduce([], { (sets: [SetData], exSet: ExSet) -> [SetData] in
                let nextSet = SetData(exId: exSet.exId, reps: String(exSet.reps ?? 0), time: String(exSet.time ?? 0), weight: String(exSet.weight ?? 0))
                var result = sets
                result.append(nextSet)
                return result
            })
            if let time = self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].time, time > 0 {
                self.timed = true
            }
        }
        .onDisappear {
            self.saveSets()
        }
    }
    
    func addSet() {
        let firstSet = self.sets[0]
        let newSet = SetData(exId: firstSet.exId, reps: firstSet.reps, time: firstSet.time, weight: firstSet.weight)
        self.sets.append(newSet)
    }
    
    func saveSets() {
        (0..<self.sets.count).forEach { i in
            if (self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx].indices.contains(i)) {
                self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][i].reps = Int(self.sets[i].reps)
                self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][i].time = Int(self.sets[i].time)
                self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][i].weight = Int(self.sets[i].weight)
            } else {
                let newExSet = ExSet(exId: self.sets[i].exId, time: Int(self.sets[i].time), reps: Int(self.sets[i].reps), weight: Int(self.sets[i].weight))
                self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx].append(newExSet)
            }
        }
    }
}

struct SelectedExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedExerciseView(trackWorkoutViewModel: TrackWorkoutViewModel(), currentRound: 0, curExIdx: 0)
    }
}
