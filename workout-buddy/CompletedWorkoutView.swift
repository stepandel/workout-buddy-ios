//
//  CompletedWorkoutView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-19.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct CompletedWorkoutView: View {
    var completedWorkout: CompletedWorkout
    
    @State var dateStr = ""
    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            
            
            HStack {
                Text("Date: \(dateStr)")
                    .padding()
                Spacer()
            }
                
            
            
            HStack {
                Text("Rounds: \(completedWorkout.workout.rounds.count)x")
                Spacer()
            }
            .padding()
            
            RoundBlock(rounds: completedWorkout.workout.rounds)
            
            Spacer()
        }.onAppear {
            self.dateFormatter.timeZone = TimeZone.current
            self.dateFormatter.locale = NSLocale.current
            self.dateFormatter.dateFormat = "MMM-d, yyyy"
            
            let date = Date(timeIntervalSince1970: self.completedWorkout.startTS)
            self.dateStr = self.dateFormatter.string(from: date)
        }.navigationBarTitle(Text("\(completedWorkout.workout.name)"))
    }
}

struct CompletedWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedWorkoutView(completedWorkout: sampleWorkoutLog[0])
    }
}
