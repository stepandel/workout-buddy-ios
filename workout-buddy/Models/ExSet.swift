//
//  ExSet.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-25.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ExSet: Hashable, Codable {
    var exId: String
    var time: Int?
    var reps: Int?
    var sets: Int
}
