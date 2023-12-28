//
//  learningApp.swift
//  learning
//
//  Created by Kazuki Minami on 2023/11/17.
//

import SwiftUI
import SwiftData

@main
struct learningApp: App {
    var container: ModelContainer
    
    init() {
        do {
            let configuration = ModelConfiguration(for: Presets.self)
            container = try ModelContainer(for: Presets.self, configurations: configuration)
        } catch {
            fatalError("Failed to create model container.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(selectedPreset: Presets(id: 9, name: "Example", focus: 15, rest: 15))
        }
        .modelContainer(container)
    }
}
