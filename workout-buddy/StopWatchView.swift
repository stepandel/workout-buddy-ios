//
//  StopWatch.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-06-08.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct StopWatchView: View {
    @ObservedObject var stopWatch = StopWatch()
    
    @State var isStarted = false
    @State var isPaused = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("\(stopWatch.timeString)")
                    .font(.largeTitle)
                    .frame(width: 145, height: 40, alignment: .leading)
//                Text("\(stopWatch.fractionString)")
//                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding()
            HStack {
                if (self.isPaused || !self.isStarted) {
                    Button(action: {
                        self.stopWatch.start()
                        self.isStarted = true
                        self.isPaused = false
                    }) {
                        Text("Start")
                    }
                }
                if (self.isStarted) {
                    Button(action: {
                        self.isPaused ? self.stopWatch.reset() : self.stopWatch.pause()
                        if (self.isPaused) {
                            self.isStarted = false
                            self.isPaused = false
                        } else {
                            self.isPaused = true
                        }
                    }) {
                        self.isPaused ? Text("Reset") : Text("Pause")
                    }
                }
            }
        }
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopWatchView()
        .previewLayout(.fixed(width: 300, height: 90))
    }
}
