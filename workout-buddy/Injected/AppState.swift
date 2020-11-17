//
//  AppState.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-13.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var userData = UserData()
    @Published var routing = ViewRouting()
    @Published var trackingData = TrackingData()
}

extension AppState {
    struct ViewRouting {
        var contentView = ContentView.Routing()
        var trackWorkout = TrackWorkout.Routing()
    }
}

extension AppState {
    struct TrackingData {
        var workout = Workout()
        var workoutStarted = false
        var startTime: Double = 0
        var currentRound = 0
        var addExAfterIdx = 0
        
        mutating func reset() {
            self.workout = Workout()
            self.workoutStarted = false
            self.startTime = 0
            self.currentRound = 0
            self.addExAfterIdx = 0
        }
    }
}
