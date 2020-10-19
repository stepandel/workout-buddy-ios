//
//  HomeView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ActivitiesView: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            List(userData.workoutLog.reversed(), id:\.wlId) { completedWorkout in
                NavigationLink(destination: CompletedWorkoutView(completedWorkout: completedWorkout)) {
                    ActivityRow(completedWorkout: completedWorkout)
                }
            }
            .navigationBarTitle("Activities")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView().environmentObject(UserData())
    }
}
