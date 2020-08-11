//
//  SelectTrackingView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-08-08.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct SelectTrackingView: View {
    
//    init() {
//        UINavigationBar.appearance().backgroundColor = .init(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
//    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: TrackWorkoutView(showingModalView: true)) {
                    Text("Select Workout")
                }
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .frame(width: 240, height: 40)
                    .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
                    .padding(.init(top: 0, leading: 0, bottom: 32, trailing: 0))
                NavigationLink(destination: TrackWorkoutView(showingModalView: false)) {
                    Text("Start New Workout")
                }
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .frame(width: 240, height: 40)
                    .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 2, x: -2, y: -2)
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 2, x: 2, y: 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        }
    }
}

struct SelectTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTrackingView()
    }
}
