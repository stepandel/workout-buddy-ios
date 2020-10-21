//
//  RoundView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct RoundBlock: View {
    @State var rounds: [Round]
    
    var body: some View {
        VStack {
            
            // TODO: - create / use OptionalView wrapper
            
            ForEach(rounds.indices) { i in
                Section(header: Text("Round \(i + 1)")) {
                    ForEach(self.rounds[i].sets, id:\.self) { sets in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(sets[0].exId.components(separatedBy: ":")[0].formatFromId())")
                                    .bold()
                            }.padding()
                            ForEach(sets.indices) { i in
                                HStack {
                                    Text("Set \(i + 1)")
                                    Spacer()
                                    if sets[i].isWeighted() {
                                        Text("+ \(sets[i].weight!)kg")
                                    } else {
                                        Text("")
                                    }
                                    Spacer()
                                    if sets[i].isTimed() {
                                        Text("\(sets[i].time!)sec")
                                    } else {
                                        Text("\(sets[i].reps ?? 0)")
                                    }
                                }.padding()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct RoundView_Previews: PreviewProvider {
    static var previews: some View {
        RoundBlock(rounds: sampleWorkouts[0].rounds)
            .previewLayout(.sizeThatFits)
        
    }
}
