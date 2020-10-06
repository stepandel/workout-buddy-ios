//
//  StringFormatter.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-06-16.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    // TODO: - Try combining these 2 functions into one

//    mutating func capitalizeFirstLetter() {
//        self = self.capitalizingFirstLetter()
//    }
    
    func formatFromId() -> String {
        var formattedStr = ""
        let words = self.components(separatedBy: "_")
        words.forEach { (str) in
            formattedStr += str.capitalizingFirstLetter() + " "
        }
        return String(formattedStr.dropLast())
    }
    
    func formatToId() -> String {
        var formattedStr = ""
        let words = self.components(separatedBy: " ")
        words.forEach { (str) in
            formattedStr += str.lowercased() + "_"
        }
        return String(formattedStr.dropLast())
    }
}
