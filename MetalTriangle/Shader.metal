//
//  Shader.metal
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 20.11.2025.
//
#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

struct Uniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]], constant Uniforms &uniforms [[buffer(1)]]) {
    VertexOut out;

    float4 worldPosition = uniforms.modelMatrix * in.position;
    float4 cameraPosition = uniforms.viewMatrix * worldPosition;
    out.position = uniforms.projectionMatrix * cameraPosition;

    return out;
}

fragment float4 fragmentShader() {
    return float4(1, 0, 0, 1);
}
