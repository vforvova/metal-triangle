//
//  Uniforms.swift
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 28.11.2025.
//

import MetalKit

struct Uniforms {
    var modelMatrix: simd_float4x4 = matrix_identity_float4x4
    var viewMatrix: simd_float4x4 = matrix_identity_float4x4
    var projectionMatrix: simd_float4x4 = matrix_identity_float4x4
}
