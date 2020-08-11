//
//  CurrentExerciseView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-06-16.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct CurrentExerciseView: View {
    @ObservedObject var trackWorkoutViewModel: TrackWorkoutViewModel
    @State var exSet: ExSet
    @State var exName = ""
    
    var body: some View {
        VStack {
            Text("\(exName)")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .frame(width: 240, height: 40)
                .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                .padding(.init(top: 0, leading: 0, bottom: 32, trailing: 0))
            
            HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "minus")
//                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .frame(width: 60, height: 60)
                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                }.padding(.trailing)
                if self.exSet.reps! > 0 {
                    Text("\(self.exSet.reps!)x")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .frame(width: 60, height: 40)
                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                } else if self.exSet.time != nil {
                    Text("\(self.exSet.time!)sec")
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
        .onAppear {
            self.exName = self.exSet.exId.components(separatedBy: ":")[0].formatId()
        }
    }
}

struct CurrentExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentExerciseView(trackWorkoutViewModel: TrackWorkoutViewModel(), exSet: (sampleWorkouts[0].rounds?[0].sets?[0])!)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
    }
}
