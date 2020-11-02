//
//  UserProfile.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-27.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct UserProfile: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        HStack {
            ProfileImage().environmentObject(userData)
            
            Spacer()
            
            if userData.didCreateAccount {
            
                VStack(alignment: .leading) {
                    Text("\(self.userData.user.firstName ?? "") \(self.userData.user.lastName ?? "")")
                        .font(.title)
                        .padding(.bottom, 16)
                    
                    if self.userData.user.city != nil || self.userData.user.city != "" {
                        Text("\(self.userData.user.city ?? ""), \(self.userData.user.state ?? "")")
                            .font(.footnote)
                    } else {
                        Text("\(self.userData.user.state ?? "")")
                            .font(.footnote)
                    }
                    
                    if self.userData.user.bio != nil || self.userData.user.bio != nil {
                        Text("\(self.userData.user.bio ?? "")")
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
        UserProfile().environmentObject(UserData())
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
