//
//  WorkoutLogRow.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-12-23.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct WorkoutLogRow: View {
    var completedWorkout: CompletedWorkout
    
    @State var dateStr = ""
    let dateFormatter = DateFormatter()
    
    var body: some View {
        
        HStack {
            Image(systemName: "circle.fill")
                .padding()
            VStack(alignment: .leading) {
                Text("\(dateStr)")
                    .font(.footnote)
                    .padding(.bottom, 4)
                Text("\(completedWorkout.workout.focus)")
                    .font(.title)
            }
            .padding()
        }
        .onAppear {
            self.dateFormatter.timeZone = TimeZone.current
            self.dateFormatter.locale = NSLocale.current
            self.dateFormatter.dateFormat = "EEE, MMM-dd"

            let date = Date(timeIntervalSince1970: self.completedWorkout.startTS)
            self.dateStr = self.dateFormatter.string(from: date)
        }
    }
}

struct WorkoutLogRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutLogRow(completedWorkout: sampleWorkoutLog[0])
    }
}
