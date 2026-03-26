//
//  TallyWidgetBundle.swift
//  TallyWidget
//
//  Created by Hardik Modha on 25/03/26.
//

import WidgetKit
import SwiftUI
import SQLiteData

@main
struct TallyWidgetBundle: WidgetBundle {
    
    init() {
        prepareDependencies { dependency in
            dependency.defaultDatabase = .appDatabase()
        }
    }
    
    var body: some Widget {
        FirstTallyWidget()
    }
}
