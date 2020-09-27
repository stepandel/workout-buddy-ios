//
//  ProfileImage.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-27.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ProfileImage: View {
    var body: some View {
        Image("popeye").resizable()
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2))
            .shadow(radius: 4)
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage()
    }
}
