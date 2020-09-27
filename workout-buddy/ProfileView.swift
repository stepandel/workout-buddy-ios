//
//  ProfileView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-27.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        List {
            Section {
                UserProfile().padding(.top).padding(.bottom)
            }
            
            Section (header: Text("")) {
                Text("Goal Progress Tracking")
            }
            
            Section(header: Text("")) {
                NavigationLink(
                    destination: Text("Nothing"),
                    label: {
                        Text("Ranking")
                    })
                NavigationLink(
                    destination: Text("Nothing"),
                    label: {
                        Text("Achievements")
                    })
                NavigationLink(
                    destination: Text("Nothing"),
                    label: {
                        Text("Stats")
                    })
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
