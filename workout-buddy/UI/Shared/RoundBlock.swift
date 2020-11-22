//
//  RoundView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct RoundBlock: View {
    var rounds: [Round]
    
    var body: some View {
//        VStack {
            
            // TODO: - create / use OptionalView wrapper
            
            ForEach(rounds) { round in
                Section(header: Text("Round \(self.rounds.firstIndex(of: round)! + 1)")) {
                    ForEach(round.sets, id:\.self) { sets in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(sets[0].exId.components(separatedBy: ":")[0].formatFromId())")
                                    .bold()
                            }.padding()
                            ForEach(sets) { set in
                                HStack {
                                    Text("Set \(sets.firstIndex(of: set)! + 1)")
                                    Spacer()
                                    if set.isWeighted() {
                                        Text("+ \(set.weight!)kg")
                                    } else {
                                        Text("")
                                    }
                                    Spacer()
                                    if set.isTimed() {
                                        Text("\(set.time!)sec")
                                    } else {
                                        Text("\(set.reps ?? 0)")
                                    }
                                }.padding()
                            }
                        }
                    }
                }
            }
//        }
    }
}

struct RoundView_Previews: PreviewProvider {
    static var previews: some View {
        RoundBlock(rounds: sampleWorkouts[0].rounds)
            .previewLayout(.sizeThatFits)
        
    }
}
