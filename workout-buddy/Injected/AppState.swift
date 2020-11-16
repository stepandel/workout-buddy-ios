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
}

extension AppState {
    struct ViewRouting {
        var contentView = ContentView.Routing()
        var trackWorkout = TrackWorkout.Routing()
    }
}
