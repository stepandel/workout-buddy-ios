//
//  ProfileImage.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-27.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ProfileImage: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        
        if userData.profileImage != nil {
            
            Image(uiImage: userData.profileImage!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .clipped()
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 4)
            
        } else {
            Image("popeye")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .clipped()
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 4)
        }
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage().environmentObject(UserData())
    }
}
