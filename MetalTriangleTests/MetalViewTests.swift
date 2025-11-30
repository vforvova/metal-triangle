//
//  MetalViewTests.swift
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 21.11.2025.
//
import Testing
@testable import MetalTriangle

struct MetalViewTests {
    @Test func testMakeCoordinator() {
        let metalView = MetalView()
        let renderer = metalView.makeCoordinator()

        #expect(renderer.device != nil, "Coordinator should have a Metal device")
        #expect(renderer.commandQueue != nil, "Coordinator should have a MTLCommandQueue")
        #expect(renderer.pipelineState != nil, "Coordinator should have a MTLRenderPipelineState")
    }
}
