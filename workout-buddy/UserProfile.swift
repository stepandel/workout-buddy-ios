//
//  UserProfile.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-27.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct UserProfile: View {
    var body: some View {
        HStack {
            ProfileImage()
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("John Doe")
                    .font(.title)
                    .padding(.bottom, 16)
                
                Text("Following / Followers")
                    .font(.footnote)
            }
        }
        .padding(.trailing, 32)
        .padding(.leading, 32)
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
