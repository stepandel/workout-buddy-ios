//
//  CurrentExerciseView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-06-16.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct CurrentExerciseView: View {
    @State var exSet: ExSet
    @State var exName = ""
    
    var body: some View {
        HStack {
            Text("\(exName)")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .frame(width: 240, height: 40)
                .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: 2, y: 2)
                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: -2, y: -2)
            Spacer()
            if self.exSet.reps! > 0 {
                Text("\(self.exSet.reps!)x")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .frame(width: 60, height: 40)
                    .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
            } else if self.exSet.time != nil {
                Text("\(self.exSet.time!)sec")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .frame(width: 60, height: 40)
                    .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
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
        CurrentExerciseView(exSet: sampleWorkouts[0].sets[0])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
    }
}
