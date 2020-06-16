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
    @State var shadowRad = 10
    @State var tap = false
    @State var press = false
    
    var body: some View {
        VStack {
            ZStack {
                Text("\(stopWatch.timeString)")
                    .frame(width: 180, height: 36, alignment: .leading)
            }
            .font(.system(size: 40, weight: .semibold))
            .frame(width: 240, height: 80)
            .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    
                    RoundedRectangle(cornerRadius: 48, style: .continuous)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 48, style: .continuous)
                        .foregroundColor(Color(#colorLiteral(red: 0.9429137546, green: 0.9462280435, blue: 0.9561709102, alpha: 1)))
                        .padding(2)
                        .blur(radius: 2)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: CGFloat(self.shadowRad), x: CGFloat(self.shadowRad), y: CGFloat(self.shadowRad))
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: CGFloat(self.shadowRad), x: CGFloat(-self.shadowRad), y: CGFloat(-self.shadowRad))
            .scaleEffect(tap ? 1.02 : 1)
            .gesture(
                LongPressGesture().onChanged { value in
                    self.tap = true
                    self.startOrPauseTime()
                    print("\(self.tap)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.tap = false
                    }
                }
                .onEnded { value in
                    self.press.toggle()
                    self.resetTime()
                }
            )
        }
        .animation(.easeInOut)
        .padding()
    }
    
    func startOrPauseTime() {
        if (self.isPaused) {
            self.stopWatch.start()
            self.shadowRad = 1
        } else {
            self.stopWatch.pause()
            self.shadowRad = 5
        }
        
        self.isPaused.toggle()
    }
    
    func resetTime() {
        self.stopWatch.reset()
        self.shadowRad = 10
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopWatchView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
    }
}
