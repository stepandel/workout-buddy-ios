//
//  ExercisesView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-21.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ExercisesView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            Exercises(exId: .constant(""), needToSelectExercise: false).environmentObject(self.appState)
        }
        .sheet(isPresented: self.$appState.routing.exrecises.isModalSheetPresented) {
            NewExerciseView().environmentObject(self.appState)
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView().environmentObject(AppState())
    }
}
