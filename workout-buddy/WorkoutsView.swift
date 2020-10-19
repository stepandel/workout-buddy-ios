//
//  WorkoutsView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct WorkoutsView: View {
    
    @EnvironmentObject var userData: UserData
    
    @State var isPresented = false
    
    var body: some View {
        NavigationView {
            List(userData.workouts) { workout in
                NavigationLink(destination: WorkoutView(workout: workout).environmentObject(self.userData)) {
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
                NewWorkoutView().environmentObject(self.userData)
            }
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView().environmentObject(UserData())
    }
}
