//
//  ContentView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            ActivitiesView()
                .environmentObject(self.userData)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Feed")
                    }
                }
                .tag(1)
            SelectTrackingView()
                .environmentObject(self.userData)
                .tabItem {
                    VStack {
                        Image(systemName: "play.circle")
                        Text("Track")
                    }
                }
                .tag(0)
//            WorkoutsView()
//                .environmentObject(self.userData)
//                .tabItem {
//                    VStack {
//                        Image(systemName: "tray.fill")
//                        Text("Workouts")
//                    }
//                }
//                .tag(2)
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData())
    }
}
