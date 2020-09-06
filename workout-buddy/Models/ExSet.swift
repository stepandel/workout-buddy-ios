//
//  ExSet.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-25.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ExSet: Hashable, Codable, Identifiable {
    var id: UUID
    var exId: String
    var time: Int?
    var reps: Int?
    var skipped: Bool?
    var completed: Bool?
    
    init(exId: String, time: Int?, reps: Int?) {
        self.id = UUID()
        self.exId = exId
        self.time = time
        self.reps = reps
    }
}
