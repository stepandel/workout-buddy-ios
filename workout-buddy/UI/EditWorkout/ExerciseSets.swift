//
//  ExerciseSetsView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-11-21.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct ExerciseSets: View {
    @EnvironmentObject var appState: AppState
    @State var sets: [SetData] = []
    @State private var timed = false
    
    private(set) var interactor: EditExerciseSetsInteractor
    
    var body: some View {
        List {
            self.header
            ForEach(self.sets) { set in
                if !set.deleted {
                    self.setRow(set: set)
                }
            }
            .onDelete { (offset) in
                let nonDeletedSets = self.sets.filter { !$0.deleted }
                if nonDeletedSets.count > 1 {
                    offset.forEach { i in
                        var deletedSet = self.sets[i]
                        deletedSet.deleted = true
                        self.sets.remove(at: i)
                        self.sets.append(deletedSet)
                    }
                }
            }
            self.addSetBtn
                .navigationBarTitle(Text("\(self.interactor.exSets[0].exId.components(separatedBy: ":")[0].formatFromId())"))
        }
        .onAppear {
            self.sets = self.interactor.getSetData()
            if let time = Int(self.sets[0].time), time > 0 {
                self.timed = true
            }
        }
        .onDisappear {
            self.interactor.saveSets(sets: self.sets)
        }
    }
}


// MARK: - Subviews

extension ExerciseSets {
    private var header: some View {
        HStack {
            Text("Set #")
                .frame(width: 52)
            Spacer()
            Text("Weight (kg)")
                .frame(width: 92)
                .padding([.leading, .trailing], 16)
            Spacer()
            if timed {
                Text("Time (sec)")
                    .frame(width: 92)
                    .padding([.leading, .trailing], 16)
            } else {
                Text("Reps")
                    .frame(width: 92)
                    .padding([.leading, .trailing], 16)
            }
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
    
    private func setRow(set: SetData) -> some View {
        return HStack {
            Text("\(self.sets.firstIndex(of: set)! + 1)")
                .frame(width: 52)
            Spacer()
            TextField("0 kg", text: self.$sets[self.sets.firstIndex(of: set)!].weight)
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .frame(width: 92, height: 40)
                .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            Spacer()
            if timed {
                TextField("0 sec", text: self.$sets[self.sets.firstIndex(of: set)!].time)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .frame(width: 80, height: 40)
                    .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                    .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            } else {
                TextField("0", text: self.$sets[self.sets.firstIndex(of: set)!].reps)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .frame(width: 80, height: 40)
                    .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
                    .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
}


// MARK: - Buttons

extension ExerciseSets {
    private var addSetBtn: some View  {
        Button(action: {
            self.addSet()
        }) {
            Text("+ Set")
        }
    }
}


extension ExerciseSets {
    func addSet() {
        let firstSet = self.sets[0]
        let newSet = SetData(exId: firstSet.exId, reps: firstSet.reps, time: firstSet.time, weight: firstSet.weight)
        let nonDeletedSets = self.sets.filter{ !$0.deleted }
        self.sets.insert(newSet, at: nonDeletedSets.count)
    }
}

struct ExerciseSets_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSets(interactor: .init(appState: AppState(), exSets: .constant([])))
    }
}
