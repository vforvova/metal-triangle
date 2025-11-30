//
//  MetalTriangleApp.swift
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 20.11.2025.
//

import SwiftUI

@main
struct MetalTriangleApp: App {
    @State private var currentStage: DemoStage = .staticTriangle

    var body: some Scene {
        WindowGroup {
            ContentView(currentStage: $currentStage)
        }
        .commands {
            CommandMenu("Stages") {
                ForEach(DemoStage.allCases) { stage in
                    Button(stage.rawValue) {
                        currentStage = stage
                    }
                    .keyboardShortcut(KeyEquivalent(Character(extendedGraphemeClusterLiteral: stage.rawValue.first ?? " ")), modifiers: .command)
                }
            }
        }
    }
}
