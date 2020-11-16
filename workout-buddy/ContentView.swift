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
        let selection = Binding<Tabs>(
            get: { self.appState.routing.contentView.selectedTab },
            set: { self.appState.routing.contentView.selectedTab = $0
                if $0 == Tabs.tracking {
                    isActionSheetPresented.toggle()
                }
            }
        )
        
        ZStack {
        
            TabView(selection: selection){
                Activities(viewModel: .init(appState: self.appState))
                    .environmentObject(self.appState)
                    .tabItem {
                        VStack {
                            Image(systemName: "folder")
                            Text("Workouts")
                        }
                    }
                    .tag(Tabs.activities)
                TrackWorkout(viewModel: .init(appState: self.appState, showingModalView: false))
                    .environmentObject(self.appState)
                    .tabItem {
                        VStack {
                            Image(systemName: "play.circle")
                            Text("Track")
                        }
                    }
                    .tag(Tabs.tracking)
                ExercisesView()
                    .environmentObject(self.appState)
                    .tabItem {
                        VStack {
                            Image(systemName: "bolt")
                            Text("Exercises")
                        }
                    }
                    .tag(Tabs.exercises)
                ProfileView()
                    .environmentObject(self.appState)
                    .tabItem {
                        VStack {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                    }
                    .tag(Tabs.profile)
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
                        appState.routing.contentView.routeToActivities()
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
    enum Tabs: Int {
        case activities = 0, tracking, exercises, profile
    }
}

extension ContentView {
    struct Routing {
        var selectedTab: Tabs = .activities
        
        mutating func routeToActivities() {
            self.selectedTab = .activities
        }
        
        mutating func routeToTracking() {
            self.selectedTab = .tracking
        }
        
        mutating func routeToExercises() {
            self.selectedTab = .exercises
        }
        
        mutating func routeToProfile()  {
            self.selectedTab = .profile
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState())
    }
}
