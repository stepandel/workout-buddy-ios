//
//  CapsuleBarChart.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-10-13.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct CapsuleBarChart: View {
    
    var data: [CGFloat]
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 8) {
                ForEach(data, id: \.self) { point in
                    BarView(value: point * 200)
                }
            }.padding(24)
            .animation(.default)
        }
    }
}

struct BarView: View {
    
    var value: CGFloat
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Capsule().frame(width: 20, height: 200)
                    .foregroundColor(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                    .opacity(0.4)
                Capsule().frame(width: 20, height: value)
                    .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
            }
            
        }
    }
}
