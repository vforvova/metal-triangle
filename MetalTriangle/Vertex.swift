//
//  Vertex.swift
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 29.11.2025.
//

struct Vertex {
    var position: SIMD3<Float>

    init(x: Float, y: Float, z: Float) {
        self.position = SIMD3<Float>(x, y, z)
    }
}


