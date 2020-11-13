//
//  ContentView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    
    @State private var isActionSheetPresented = false
 
    var body: some View {
        let selection = Binding<Int>(
            get: { self.userData.selectedTab },
            set: { self.userData.selectedTab = $0
                if $0 == 1 {
                    isActionSheetPresented.toggle()
                }
            }
        )
        
        ZStack {
        
            TabView(selection: selection){
                ActivitiesView()
                    .environmentObject(self.userData)
                    .tabItem {
                        VStack {
                            Image(systemName: "folder")
                            Text("Workouts")
                        }
                    }
                    .tag(0)
                TrackWorkout(viewModel: .init(userData: self.userData, showingModalView: false))
                    .environmentObject(self.userData)
                    .tabItem {
                        VStack {
                            Image(systemName: "play.circle")
                            Text("Track")
                        }
                    }
                    .tag(1)
                ExercisesView()
                    .environmentObject(userData)
                    .tabItem {
                        VStack {
                            Image(systemName: "bolt")
                            Text("Exercises")
                        }
                    }
                    .tag(2)
                ProfileView()
                    .environmentObject(self.userData)
                    .tabItem {
                        VStack {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                    }
                    .tag(3)
            }.actionSheet(isPresented: $isActionSheetPresented) {
                ActionSheet(title: Text("Start Workout"), buttons: [
                    .default(Text("Start New")) {
                        userData.trackingStatus.started = true
                    },
                    .default(Text("Select Previously Completed")) {
                        userData.trackingStatus.new = false
                        userData.trackingStatus.started = true
                    },
                    .cancel() {
                        userData.selectedTab = 0
                    }
                ])
            }
            
            if userData.trackingStatus.started {
                TrackWorkout(viewModel: .init(userData: self.userData, showingModalView: false))
                    .environmentObject(self.userData)
            }
            
            if !userData.isLoggedIn {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData())
    }
}
