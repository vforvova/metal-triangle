//
//  MetalView.swift
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 20.11.2025.
//

import SwiftUI
import MetalKit

struct MetalView: NSViewRepresentable {
    var isDynamic: Bool = false

    func makeCoordinator() -> Renderer {
        let renderer = Renderer()

        if isDynamic {
            renderer.withRotation(params: RotationParams())
        }

        return renderer
    }

    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()!
        view.clearColor = MTLClearColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        view.delegate = context.coordinator
        return view
    }

    func updateNSView(_ nsView: MTKView, context: Context) {}
}
