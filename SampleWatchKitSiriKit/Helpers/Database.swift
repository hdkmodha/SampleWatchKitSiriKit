//
//  Database.swift
//  SampleWatchKitSiriKit
//
//  Created by Hardik Modha on 25/03/26.
//

import Foundation
import SQLiteData

public protocol DatabaseMigrating {
    static func migrate(using migrator: inout DatabaseMigrator) throws
}

extension DatabaseWriter where Self == DatabaseQueue {
    public static func appDatabase() -> any DatabaseWriter {
        var configuration = Configuration()
        configuration.foreignKeysEnabled = true
        
        configuration.prepareDatabase { db in
            #if DEBUG
            db.trace(options: .profile) {
                print($0.description)
            }
            #endif
        }
        
        let path = URL.documentsDirectory.appending(path: "db.sqlite").path()
        print("Database path: \(path)")
        let database = try! SQLiteData.defaultDatabase(path: path, configuration: configuration)
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        try! Tally.migrate(using: &migrator)
        
        //MARK: - Migrator
        try! migrator.migrate(database)
        
        return database
    }
}

extension DependencyValues {
    func seedDatabaseForPreviews() throws {
        try defaultDatabase.write { db in
            try db.seed {
                Tally.mockTallies
            }
        }
    }
}
