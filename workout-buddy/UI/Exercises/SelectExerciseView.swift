//
//  SelectExerciseView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-05-26.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct SelectExerciseView: View {
    @EnvironmentObject var appState: AppState
    @Binding var exId: String
    
    var body: some View {
        NavigationView {
            Exercises(exId: self.$exId, needToSelectExercise: true).environmentObject(self.appState)
        }
        .sheet(isPresented: self.$appState.routing.exrecises.isModalSheetPresented) { NewExerciseView().environmentObject(self.appState) }
    }
}

struct SelectExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        SelectExerciseView(exId: .constant("")).environmentObject(AppState())
    }
}
