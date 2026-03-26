//
//  UpdateTallyIntent.swift
//  SampleWatchKitSiriKit
//
//  Created by Hardik Modha on 26/03/26.
//

import AppIntents
import SQLiteData
import WidgetKit
import SwiftUI

struct UpdateTallyIntent: AppIntent {
    
    
    
    static var title: LocalizedStringResource = LocalizedStringResource(stringLiteral: "Update first tally")
    static var description: IntentDescription? = IntentDescription(stringLiteral: "Tap the tally once to increment")
    
    func perform() async throws -> some IntentResult {
        let update = await updateTally()
        return .result(value: update)
    }
    
    @MainActor
    func updateTally() -> Int {
        @FetchAll(Tally.order(by: \.name)) var tallies: [Tally]
        if var tally = tallies.first {
            tally.increase()
            WidgetCenter.shared.reloadAllTimelines()
            return tally.value
        }
        return 0
    }
}
