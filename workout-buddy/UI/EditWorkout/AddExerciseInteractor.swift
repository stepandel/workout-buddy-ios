//
//  AddExerciseInteractor.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-22.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct AddExerciseInteractor {
    @Binding var round: Round
    var appState: AppState
    
    init(appState: AppState, round: Binding<Round>) {
        self.appState = appState
        self._round = round
    }
    
    func addExSet(exId: String, time: String, reps: String, weight: String, timed: Bool) {
        if timed {
            let newExSet = ExSet(exId: exId, time: Int(time), reps: 0, weight: Int(weight))
            self.round.sets.append([newExSet])
        } else {
            let newExSet = ExSet(exId: exId, time: 0, reps: Int(reps), weight: Int(weight))
            self.round.sets.append([newExSet])
        }
    }
}
