//
//  RoundView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-04-05.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct RoundBlock: View {
    @State var sets: [ExSet]
    @State var rounds: [Round]?
    
    var body: some View {
        VStack {
            
            // TODO: - create / use OptionalView wrapper
            
            if (rounds != nil) {
                ForEach(rounds!, id:\.self) { round in
                    Section(header: Text("Round \(round.id + 1)")) {
                        List(round.sets ?? [], id:\.exId) { set in
                            HStack {
                                Text("\(set.exId)")
                                Spacer()
                                if set.reps ?? 0 > 0 {
                                    Text("\(set.reps!)x")
                                } else if set.time != nil {
                                    Text("\(set.time!)sec")
                                }
                            }
                        }
                    }
                }
            } else {
                List(sets, id:\.exId) { set in

                    HStack {
                        Text(set.exId.split(separator: ":")[0])
                        Spacer()
                        if set.reps != nil {
                            Text("\(set.reps!)x")
                        } else if set.time != nil {
                            Text("\(set.time!)sec")
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct RoundView_Previews: PreviewProvider {
    static var previews: some View {
        RoundBlock(sets: sampleWorkouts[0].sets, rounds: sampleWorkouts[0].rounds)
            .previewLayout(.sizeThatFits)
        
    }
}
