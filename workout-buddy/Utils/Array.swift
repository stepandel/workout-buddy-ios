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


// MARK: - 2D Array

extension Array where Element : Collection, Element.Iterator.Element : Equatable, Element.Index == Int {
    
    func indices(of x: Element.Iterator.Element) -> (Int, Int)? {
        for (i, row) in self.enumerated() {
            if let j = row.firstIndex(of: x) {
                return (i, j)
            }
        }
        return nil
    }
}

