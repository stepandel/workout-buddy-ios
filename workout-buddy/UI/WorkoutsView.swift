//
//  WorkoutsView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct WorkoutsView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State var isPresented = false
    
    var body: some View {
        NavigationView {
            List(appState.userData.workouts) { workout in
                NavigationLink(destination: WorkoutView(workout: workout).environmentObject(self.appState)) {
                    WorkoutRow(workout: workout)
                }
            }
            .navigationBarTitle("Workouts")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isPresented.toggle()
                }) {
                    Image(systemName: "plus")
                })
            .popover(isPresented: self.$isPresented) {
                NewWorkoutView().environmentObject(self.appState)
            }
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView().environmentObject(AppState())
    }
}
