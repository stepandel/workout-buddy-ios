//
//  ActivitiesRow.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ActivityRow: View {
    var workout: Workout
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(workout.name)
                    .font(.title)
                HStack {
                    Text(workout.focus)
                        .font(.subheadline)
                    Spacer()
                    Text(workout.type.rawValue)
                        .font(.caption)
                }
            }
            .padding()
        }
    }
}

struct ActivitiesRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRow(workout: workoutData[0])
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
