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
                    List(self.rounds[i].sets, id:\.self) { set in
                        HStack {
                            Text("\(set[0].exId.components(separatedBy: ":")[0].formatFromId())")
                            Spacer()
                            if set[0].reps ?? 0 > 0 {
                                Text("\(set[0].reps!)x")
                            } else if set[0].time != nil {
                                Text("\(set[0].time!)sec")
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
