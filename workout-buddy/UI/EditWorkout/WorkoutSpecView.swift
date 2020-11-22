//
//  WorkoutSpecView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-21.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct WorkoutSpecView: View {
    @Binding var workout: Workout
    
    var body: some View {
        Section {
            TextField("New Workout", text: self.$workout.name)
            HStack {
                Text("Focus: ")
                Spacer()
                TextField("Focus", text: self.$workout.focus)
            }
            if #available(iOS 14.0, *) {
                VStack(alignment: .leading) {
                    Text("Notes: ")
                    TextEditor(text: self.$workout.notes)
                        .frame(minHeight: 100)
                }
            }
        }
    }
}

struct WorkoutSpecView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            WorkoutSpecView(workout: .constant(Workout()))
        }
    }
}
