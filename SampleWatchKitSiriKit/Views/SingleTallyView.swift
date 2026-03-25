//
//  SingleTallyView.swift
//  SampleWatchKitSiriKit
//
//  Created by Hardik Modha on 25/03/26.
//

import SwiftUI
import SQLiteData

struct SingleTallyView: View {
    
    let size: Double
    @Binding var tally: Tally?
    
    @Dependency(\.defaultDatabase) var database
    
    
    var body: some View {
        Group {
            if var tally {
                Text("\(tally.value)")
                    .font(.system(size: size, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .minimumScaleFactor(0.5)
                    .padding()
                    .frame(width: size * 1.5, height: size * 1.5)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.clear).stroke(.primary, lineWidth: 5))
                    .onTapGesture {
                        withAnimation {
                            tally.increase()
                            do {
                                try database.write { db in
                                    try Tally.upsert { tally }.execute(db)
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        }
                    }
                    .onTapGesture(count: 2) {
                        withAnimation {
                            tally.decrease()
                            do {
                                try database.write { db in
                                    try Tally.upsert { tally }.execute(db)
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var tally: Tally? = Tally(name: "Alpha", value: 0)
    SingleTallyView(size: 100, tally: $tally)
}
