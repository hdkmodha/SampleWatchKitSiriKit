//
//  SampleWatchKitSiriKitApp.swift
//  SampleWatchKitSiriKit
//
//  Created by Hardik Modha on 25/03/26.
//

import SwiftUI
import SQLiteData

@main
struct SampleWatchKitSiriKitApp: App {
    
    init() {
        prepareDependencies { dependencies in
            dependencies.defaultDatabase = .appDatabase()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
