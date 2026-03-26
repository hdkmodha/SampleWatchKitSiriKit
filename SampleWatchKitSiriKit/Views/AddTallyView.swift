//
//  AddTallyView.swift
//  SampleWatchKitSiriKit
//
//  Created by Hardik Modha on 25/03/26.
//

import SwiftUI
import SQLiteData
import WidgetKit

struct AddTallyView: View {
    
    @State private var name: String = ""
    @Dependency(\.defaultDatabase) var database
    @FetchAll(Tally.order(by: \.name)) var tallies: [Tally]
    @Binding var tally: Tally?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                Button {
                    let newTally = Tally(name: name, value: 10)
                    do {
                        try database.write { db in
                            try Tally.upsert { newTally }
                            .execute(db)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    tally = newTally
                    WidgetCenter.shared.reloadAllTimelines()
                    dismiss()
                } label: {
                    Text("Add")
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .disabled(name.isEmpty || tallies.map{$0.name}.contains(name))
                Spacer()

            }
            .padding()
            .navigationTitle("New Tally")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
            }
        }
    }
}

//#Preview {
//    AddTallyView()
//}
