//
//  ContentView.swift
//  SampleWatchKitSiriKit
//
//  Created by Hardik Modha on 25/03/26.
//

import SwiftUI
import SQLiteData

struct ContentView: View {
    
    @FetchAll(Tally.order(by: \.name)  ) var tallies: [Tally]
    @Dependency(\.defaultDatabase) var database
    @State private var selectedTally: Tally?
    @State private var isPresent: Bool = false
    
    var body: some View {
        NavigationStack {
            
            VStack {
                if tallies.isEmpty {
                    ContentUnavailableView("Create your first tally", systemImage: "info.triangle")
                } else {
                    Picker("Select your tally", selection: $selectedTally) {
                        Text("Select Tally").tag(nil as Tally?)
                        ForEach(tallies) { tally in
                            Text(tally.name)
                                .tag(tally as Tally?)
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    
                    if selectedTally != nil {
                        SingleTallyView(size: 100, tally: $selectedTally)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("My Tallies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.isPresent.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            
            
        }
        .sheet(isPresented: $isPresent, content: {
            AddTallyView(tally: $selectedTally)
                .presentationDetents([.medium])
        })
        .onAppear {
            if !tallies.isEmpty {
                selectedTally = tallies.first
            }
        }
        
    }
}

#Preview {
    
   let _ = prepareDependencies { dependencies in
        dependencies.defaultDatabase = .appDatabase()
        do {
            try dependencies.seedDatabaseForPreviews()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    ContentView()
}
