//
//  EditExerciseSetsInteractor.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-22.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct EditExerciseSetsInteractor {
    @Binding var exSets: [ExSet]
    let appState: AppState
    
    init(appState: AppState, exSets: Binding<[ExSet]>) {
        self.appState = appState
        self._exSets = exSets
    }
    
    func getSetData() -> [SetData] {
        return self.exSets.reduce([], { (sets: [SetData], exSet: ExSet) -> [SetData] in
            let nextSet = SetData(exId: exSet.exId, reps: String(exSet.reps ?? 0), time: String(exSet.time ?? 0), weight: String(exSet.weight ?? 0))
            var result = sets
            result.append(nextSet)
            return result
        })
    }
    
    func saveSets(sets: [SetData], timed: Bool) {
        self.exSets = []
        (0..<sets.count).forEach { i in
            if !sets[i].deleted {
                if timed {
                    let newExSet = ExSet(exId: sets[i].exId, time: Int(sets[i].time), reps: nil, weight: Int(sets[i].weight))
                    self.exSets.append(newExSet)
                } else {
                    let newExSet = ExSet(exId: sets[i].exId, time: nil, reps: Int(sets[i].reps), weight: Int(sets[i].weight))
                    self.exSets.append(newExSet)
                }
            }
        }
    }
}
