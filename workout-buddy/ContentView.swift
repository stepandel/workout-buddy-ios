//
//  ContentView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var isActionSheetPresented = false
 
    var body: some View {
        let selection = Binding<Int>(
            get: { self.appState.routing.contentView.selectedTab },
            set: { self.appState.routing.contentView.selectedTab = $0
                if $0 == 1 {
                    isActionSheetPresented.toggle()
                }
            }
        )
        
        ZStack {
        
            TabView(selection: selection){
                ActivitiesView()
                    .environmentObject(self.appState)
                    .tabItem {
                        VStack {
                            Image(systemName: "folder")
                            Text("Workouts")
                        }
                    }
                    .tag(0)
                TrackWorkout(viewModel: .init(appState: self.appState, showingModalView: false))
                    .environmentObject(self.appState)
                    .tabItem {
                        VStack {
                            Image(systemName: "play.circle")
                            Text("Track")
                        }
                    }
                    .tag(1)
                ExercisesView()
                    .environmentObject(self.appState)
                    .tabItem {
                        VStack {
                            Image(systemName: "bolt")
                            Text("Exercises")
                        }
                    }
                    .tag(2)
                ProfileView()
                    .environmentObject(self.appState)
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
                        appState.userData.trackingStatus.started = true
                    },
                    .default(Text("Select Previously Completed")) {
                        appState.userData.trackingStatus.new = false
                        appState.userData.trackingStatus.started = true
                    },
                    .cancel() {
                        appState.routing.contentView.selectedTab = 0
                    }
                ])
            }
            
            if appState.userData.trackingStatus.started {
                TrackWorkout(viewModel: .init(appState: self.appState, showingModalView: false))
                    .environmentObject(self.appState)
            }
            
            if !appState.userData.isLoggedIn {
                LoginView()
            }
        }
    }
}


// MARK: - Routing

extension ContentView {
    struct Routing {
        var selectedTab: Int = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState())
    }
}
