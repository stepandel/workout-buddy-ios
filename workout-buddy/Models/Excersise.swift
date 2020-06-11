//
//  Excersise.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct Exercise: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var excersiseType: ExcersiseType
    
    
    enum ExcersiseType: String, Hashable, Codable {
        case exp = "Explosive"
        case power = "Power"
        case stat = "Static"
        case iso = "Isometric"
    }
}
