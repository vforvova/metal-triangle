//
//  DemoStage.swift
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 23.11.2025.
//

enum DemoStage: String, CaseIterable, Identifiable {
    case staticTriangle = "Static Triangle"
    case dynamicTriangle = "Dynamic Triangle"

    var id: String { self.rawValue }
}
