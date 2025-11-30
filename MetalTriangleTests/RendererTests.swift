//
//  RendererTests.swift
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 20.11.2025.
//

import Testing
@testable import MetalTriangle

struct RendererTests {
    @Test func testInitialization() {
        let renderer = Renderer()

        #expect(renderer.device != nil, "Rendrer should initialize Metal device")
        #expect(renderer.commandQueue != nil, "Rendrer should initialize Metal command queue")
        #expect(renderer.pipelineState != nil, "Rendrer should initialize Metal pipeline state")
    }
}
