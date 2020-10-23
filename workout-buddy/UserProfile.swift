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
            
            VStack(alignment: .leading) {
                Text("\(self.userData.firstName ?? "") \(self.userData.lastName ?? "")")
                    .font(.title)
                    .padding(.bottom, 16)
                
                if self.userData.city != nil || self.userData.city != "" {
                    Text("\(self.userData.city ?? ""), \(self.userData.state ?? "")")
                        .font(.footnote)
                } else {
                    Text("\(self.userData.state ?? "")")
                        .font(.footnote)
                }
                
                if self.userData.bio != nil || self.userData.bio != nil {
                    Text("\(self.userData.bio ?? "")")
                        .padding(.top)
                }
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
