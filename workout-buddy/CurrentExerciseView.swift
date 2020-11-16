//
//  CurrentExerciseView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-06-16.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct CurrentExerciseView: View {
    @ObservedObject var trackWorkoutViewModel: TrackWorkout.ViewModel
    @State var currentRound: Int
    @State var curExIdx: Int
    
    var body: some View {
        VStack {
            Spacer(minLength: 160)
                                
            // TODO: Update StopWatch placement - taking too much space
    //                    HStack {
    //                        StopWatchView()
    //                    }
            
            if (self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets.indices.contains(self.curExIdx)) {
                
                // Current Exercise View
                VStack {
                    HStack {
                        Button(action: {
                            if (self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].completed != false) {
                                self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].completed = false
                            } else {
                                // Mark exercise as complete
                                self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].completed = true
                                
                                let indexSet = IndexSet.init(integer: self.curExIdx)
                                
                            }
                        }) {
                            Text("\(trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].exId.components(separatedBy: ":")[0].formatFromId())")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                .frame(width: 240, height: 40)
                                .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                        }
                        .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 16))
                        
                        VStack {
                            Button(action: {
                                if self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].reps! > 0 {
                                    self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].reps! += 1
                                } else if self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].time != nil {
                                    self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].time! += 1
                                }
                            }) {
                                Image(systemName: "arrowtriangle.up.fill")
                                    .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
    //                                        .frame(width: 60, height: 60)
    //                                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
    //                                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                            }.padding(.bottom)
                            if self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].reps! > 0 {
                                Text("\(self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].reps!)x")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                    .frame(width: 80, height: 40)
                                    .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                                    .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                            } else if self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].time != nil {
                                Text("\(self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].time!)sec")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                    .frame(width: 60, height: 40)
                                    .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                                    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            Button(action: {
                                if self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].reps! > 0 {
                                    self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].reps! -= 1
                                } else if self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].time != nil {
                                    self.trackWorkoutViewModel.workout.rounds[self.currentRound].sets[self.curExIdx][0].time! -= 1
                                }
                            }) {
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
    //                                        .frame(width: 60, height: 60)
    //                                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
    //                                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                            }.padding(.top)
                        }
                    
                    }
                    
                    Button(action: { }) {
                        Text("+ Exercise")
                    }
                    
                }
                .padding(.init(top: 32, leading: 32, bottom: 16, trailing: 32))
            } else {
                
                // Display Add Exercise and Add Round Buttons
                
                VStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "plus")
                                .frame(width: 60, height: 60)
                                .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                    }.padding(.bottom)
                    Button(action: {
                        
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
            }                }
            .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
    }
}

struct CurrentExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentExerciseView(trackWorkoutViewModel: TrackWorkout.ViewModel(appState: AppState()), currentRound: 0, curExIdx: 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
    }
}
