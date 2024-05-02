//
//  BinSpectApp.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 23/04/24.
//

import SwiftUI
import SwiftData

@main
struct BinSpectApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            History.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationView()
        }
        .modelContainer(sharedModelContainer)
    }
}
