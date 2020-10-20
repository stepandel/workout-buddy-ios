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
    
//    init() {
//        if #available(iOS 14.0, *) {
//            UINavigationBar.appearance().backgroundColor  = UIColor(Constants.Colors.appBackground)
//        }
//    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userData.workoutLog.reversed(), id:\.wlId) { completedWorkout in
                    Section(header: Text("")) {
                        NavigationLink(destination: CompletedWorkoutView(completedWorkout: completedWorkout)) {
                            ActivityRow(completedWorkout: completedWorkout)
                        }
                    }
                }
//                .listRowBackground(Constants.Colors.appBackground)
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
