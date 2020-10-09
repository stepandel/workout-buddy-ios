//
//  ProfileView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-27.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userData: UserData
    
    @State var isEditPresented = false
    
    
    var body: some View {
        NavigationView {
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
                        destination: StatsView().environmentObject(userData),
                        label: {
                            Text("Statistics")
                        })
                }
            }.sheet(isPresented: $isEditPresented) {
                EditProfileView()
            }.listStyle(GroupedListStyle())
            .navigationBarItems(
                leading: Button(action: { self.isEditPresented.toggle() }) { Text("Edit") },
                trailing: Button(action: { self.userData.logOutUser() }) { Text("Log Out") }
            ).navigationBarTitle(Text("Profile"), displayMode: .inline)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(UserData())
    }
}
