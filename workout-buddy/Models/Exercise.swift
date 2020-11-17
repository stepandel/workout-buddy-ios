//
//  Excersise.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct Exercise: Hashable, Codable, Identifiable, Comparable {
    static func < (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id < rhs.id
    }
    
    var id: String
    var bodyPart: String?
    var muscleGroup: String?
    
    init(id: String, bodyPart: String, muscleGroup: String) {
        self.id = id
        self.bodyPart = bodyPart
        self.muscleGroup = muscleGroup
    }
}
