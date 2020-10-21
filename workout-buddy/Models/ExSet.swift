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
    var weight: Int?
    var skipped: Bool?
    var completed: Bool?
    
    init(exId: String, time: Int?, reps: Int?, weight: Int?) {
        self.id = UUID()
        self.exId = exId
        self.time = time
        self.reps = reps
        self.weight = weight
    }
    
    func isTimed() -> Bool {
        if let time = self.time, time > 0 {
            return true
        } else {
            return false
        }
    }
    
    func isWeighted() -> Bool {
        if let weight = self.weight, weight > 0 {
            return true
        } else {
            return false
        }
    }
}
