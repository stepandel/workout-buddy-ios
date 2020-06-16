//
//  StopWatch.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-06-08.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI
import UIKit

class StopWatch: ObservableObject {
    @Published var timeString = "00:00.00"
//    @Published var fractionString = ".000"
    var (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
    private var timer = Timer()
    
    let timeFormatter = NumberFormatter()
//    let fractionsFormatter = NumberFormatter()
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StopWatch.keepTimer), userInfo: nil, repeats: true)
    }
    
    func pause() {
        timer.invalidate()
    }
    
    func reset() {
        timer.invalidate()
        (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
        timeString = "00:00.00"
    }
    
    @objc func keepTimer() {
        fractions += 1
        
        if (fractions > 99) {
            seconds += 1
            fractions = 0
        }
        
        if (seconds > 59) {
            minutes += 1
            seconds = 0
        }
        
//        if (minutes > 59) {
//            hours += 1
//            minutes = 0
//        }
        
        // TODO: - Update timeString
        timeFormatter.minimumIntegerDigits = 2
//        fractionsFormatter.minimumIntegerDigits = 3
        timeString = "\(timeFormatter.string(from: NSNumber(value: minutes)) ?? "00"):\(timeFormatter.string(from: NSNumber(value: seconds)) ?? "00").\(timeFormatter.string(from: NSNumber(value: fractions)) ?? "00")"
//        fractionString = ".\(fractionsFormatter.string(from: NSNumber(value: fractions)) ?? "000")"
    }
}
