//
//  ProfileView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-27.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    @State var isEditPresented = false
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    UserProfile().padding(.top).padding(.bottom)
                }
                
//                Section (header: Text("")) {
//                    Text("Goal Progress Tracking")
//                }
                
//                Section(header: Text("Statistics")) {
//                    NavigationLink(
//                        destination: Text("Nothing"),
//                        label: {
//                            Text("Ranking")
//                        })
//                    NavigationLink(
//                        destination: Text("Nothing"),
//                        label: {
//                            Text("Achievements")
//                        })
//                    NavigationLink(
//                        destination: StatsView().environmentObject(userData),
//                        label: {
//                            Text("Statistics")
//                        })
                    
                    StatsView().environmentObject(appState)
//                }
            }.sheet(isPresented: $isEditPresented) {
                EditProfileView()
            }.listStyle(GroupedListStyle())
            .navigationBarItems(
                leading: self.appState.userData.didCreateAccount ? AnyView(Button(action: { self.isEditPresented.toggle() }) { Text("Edit") }) : AnyView(EmptyView()),
                trailing: Button(action: { self.appState.logOutUser() }) { self.appState.userData.didCreateAccount ? Text("Log Out") : Text("Sign up") }
            ).navigationBarTitle(Text("Profile"), displayMode: .inline)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AppState())
    }
}
