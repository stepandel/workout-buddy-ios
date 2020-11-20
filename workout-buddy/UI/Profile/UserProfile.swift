//
//  UserProfile.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-27.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct UserProfile: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            ProfileImage().environmentObject(appState)
            
            Spacer()
            
            if appState.userData.didCreateAccount {
            
                VStack(alignment: .leading) {
                    Text("\(self.appState.userData.user.firstName ?? "") \(self.appState.userData.user.lastName ?? "")")
                        .font(.title)
                        .padding(.bottom, 16)
                    
                    if self.appState.userData.user.city != nil || self.appState.userData.user.city != "" {
                        Text("\(self.appState.userData.user.city ?? ""), \(self.appState.userData.user.state ?? "")")
                            .font(.footnote)
                    } else {
                        Text("\(self.appState.userData.user.state ?? "")")
                            .font(.footnote)
                    }
                    
                    if self.appState.userData.user.bio != nil || self.appState.userData.user.bio != nil {
                        Text("\(self.appState.userData.user.bio ?? "")")
                            .padding(.top)
                    }
                }
                
            } else {
                HStack {
                    Text("Me")
                    Spacer()
                }.padding(.leading)
            }
        }
        .padding(.trailing, 32)
        .padding(.leading, 32)
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile().environmentObject(AppState())
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
