//
//  Array.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-17.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

extension Array where Element: Hashable {
    mutating func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() { // In order to mutate original array
        self = self.removingDuplicates()
    }
}
