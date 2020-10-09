//
//  ActivityRow.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-19.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ActivityRow: View {
    var completedWorkout: CompletedWorkout
    
    @State var dateStr = ""
    let dateFormatter = DateFormatter()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(completedWorkout.workout.name)
                    .font(.title)
                HStack {
                    Spacer()
                    Text("\(dateStr)")
                        .padding(.trailing)
                }
            }
            .padding()
        }.onAppear {
            self.dateFormatter.timeZone = TimeZone.current
            self.dateFormatter.locale = NSLocale.current
            self.dateFormatter.dateFormat = "MMM-d, yyyy"
            
            let date = Date(timeIntervalSince1970: self.completedWorkout.startTS)
            self.dateStr = self.dateFormatter.string(from: date)
        }
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRow(completedWorkout: sampleWorkoutLog[0])
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
