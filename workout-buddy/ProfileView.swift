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
        List {
            Section {
                HStack {
                    
                    Text("Edit")
                        .padding()
                        .onTapGesture(perform: {
                            self.isEditPresented.toggle()
                        })
                    
                    Spacer()
                    
                    Text("Log Out")
                        .padding()
                        .onTapGesture(perform: {
                            self.userData.logOutUser()
                        })
                }
            }
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
        }.sheet(isPresented: $isEditPresented) {
            EditProfileView()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(UserData())
    }
}
