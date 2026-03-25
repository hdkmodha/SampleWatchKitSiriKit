//
//  Tally.swift
//  SampleWatchKitSiriKit
//
//  Created by Hardik Modha on 25/03/26.
//

import Foundation
import SQLiteData

@Table
struct Tally: Identifiable, Hashable {
    var id: UUID
    var name: String
    var value: Int
    
    init(id: UUID = UUID(), name: String, value: Int = 0) {
        self.id = id
        self.name = name
        self.value = value
    }
    
}

extension Tally {
    
    mutating func increase() {
        value += 1
    }
    
    mutating func decrease() {
        if value > 0 {
            value -= 1
        }
    }
    
    mutating func reset() {
        value = 0
    }
    
    static var mockTallies: [Tally] {
        return [
            .init(name: "Alpha"),
            .init(name: "Beta", value: 10)
        ]
    }
}

extension Tally: DatabaseMigrating {
    static func migrate(using migrator: inout GRDB.DatabaseMigrator) throws {
        migrator.registerMigration("Create table \(Self.tableName)") { db in
            try db.create(table: Self.tableName) { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("value", .integer).notNull()
            }
        }
    }
}
