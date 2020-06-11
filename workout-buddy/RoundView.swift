//
//  RoundView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct RoundBlock: View {
    var body: some View {
        VStack {
            HStack {
                Text("Round 1")
                    .font(.headline)
                Spacer()
                Text("10 min")
                    .font(.footnote)
            }
            .padding()
            
            HStack {
                Text("Push ups")
                Spacer()
                Text("10 x")
            }
            .padding()
            
            HStack {
                Text("Pull ups")
                Spacer()
                Text("10 x")
            }
            .padding()
        }
    }
}

struct RoundView_Previews: PreviewProvider {
    static var previews: some View {
        RoundBlock()
            .previewLayout(.sizeThatFits)
        
    }
}
