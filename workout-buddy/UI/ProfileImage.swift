//
//  ProfileImage.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-27.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ProfileImage: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        if appState.userData.user.profileImage != nil {
            
            Image(uiImage: appState.userData.user.profileImage!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .clipped()
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 4)
            
        } else {
            Image("profilePlaceholder")
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
        ProfileImage().environmentObject(AppState())
    }
}
