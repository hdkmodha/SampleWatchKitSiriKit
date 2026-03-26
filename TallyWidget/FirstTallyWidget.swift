//
//  TallyWidget.swift
//  TallyWidget
//
//  Created by Hardik Modha on 25/03/26.
//

import WidgetKit
import SwiftUI
import SQLiteData
import AppIntents

struct Provider: TimelineProvider {
    
    
    
    func placeholder(in context: Context) -> FirstTallyEntry {
        FirstTallyEntry(date: Date(), tallies: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (FirstTallyEntry) -> ()) {
        let curretDate = Date.now
        Task {
            let allTalies = try await loadTallies()
            let entry = FirstTallyEntry(date: curretDate, tallies: allTalies)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date.now
        Task {
            let allTallies = try await loadTallies()
            let entry = FirstTallyEntry(date: currentDate, tallies: allTallies)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
    
    @MainActor
    func loadTallies() throws -> [Tally] {
        @FetchAll(Tally.order(by: \.name)) var tallies: [Tally]
        return tallies
    }

}

struct FirstTallyEntry: TimelineEntry {
    let date: Date
    let tallies: [Tally]
    
}

struct FirstTallyEntryWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        if entry.tallies.isEmpty {
            ContentUnavailableView("No tallies yet", systemImage: "plus.circle.fill")
        } else {
            VStack {
                Button(intent: UpdateTallyIntent()) {
                    SingleTallyView(size: 60, tally: .constant(entry.tallies.first))
                }
                .buttonStyle(.plain)
                Text(entry.tallies.first!.name)
            }
        }
    }
}

struct FirstTallyWidget: Widget {
    let kind: String = "FirstTallyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FirstTallyEntryWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("First Tally")
        .description("The value of the First Tally.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    FirstTallyWidget()
} timeline: {
    FirstTallyEntry(date: Date(), tallies: [])
}
