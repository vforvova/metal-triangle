//
//  Renderer.swift
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 20.11.2025.
//

import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!

    private var rotationParams: RotationParams? = nil

    private var uniforms = Uniforms()
    private var uniformsBuffer: MTLBuffer!

    private var vertices: [Vertex] = [
        .init(x:  0.0, y:  0.5, z: 0.0),
        .init(x: -0.5, y: -0.5, z: 0.0),
        .init(x:  0.5, y: -0.5, z: 0.0)
    ]
    private var verticesBuffer: MTLBuffer!

    override init() {
        super.init()
        self.device = MTLCreateSystemDefaultDevice()
        self.commandQueue = device.makeCommandQueue()

        setupPipeline()
        setupBuffers()
    }

    private func setupPipeline() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")

        let vertexDescriptor = MTLVertexDescriptor()

        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[0].stepFunction = .perVertex
        vertexDescriptor.layouts[0].stepRate = 1

        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.vertexDescriptor = vertexDescriptor
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError("Failed to create pipeline state: \(error)")
        }
    }
    
    private func setupBuffers() {
        // Create uniforms buffer
        uniformsBuffer = device.makeBuffer(
            length: MemoryLayout<Uniforms>.stride,
            options: [.storageModeShared]
        )
        
        guard uniformsBuffer != nil else {
            fatalError("Failed to create uniforms buffer")
        }
        
        // Create vertices buffer once
        verticesBuffer = device.makeBuffer(
            bytes: vertices,
            length: MemoryLayout<Vertex>.stride * vertices.count,
            options: []
        )
        
        guard verticesBuffer != nil else {
            fatalError("Failed to create vertices buffer")
        }
    }

    func withRotation(params: RotationParams) {
        self.rotationParams = params
    }

    private func matrix4x4_rotation(axis: Vertex, angle: Float) -> simd_float4x4 {
        let normalizedAxis = normalize(axis.position)
        let ct = cos(angle)
        let st = sin(angle)
        let ci = 1 - ct

        let x = normalizedAxis.x, y = normalizedAxis.y, z = normalizedAxis.z

        return simd_float4x4(
            SIMD4<Float>(ct + x*x*ci, x*y*ci - z*st, x*z*ci + y*st, 0),
            SIMD4<Float>(y*x*ci + z*st, ct + y*y*ci, y*z*ci - x*st, 0),
            SIMD4<Float>(z*x*ci - y*st, z*y*ci + x*st, ct + z*z*ci, 0),
            SIMD4<Float>(0, 0, 0, 1),
        )
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else {
            return
        }

        guard let pipelineState = pipelineState else {
            print("Pipeline state is nil")
            return
        }
        
        guard let verticesBuffer = verticesBuffer,
              let uniformsBuffer = uniformsBuffer else {
            print("Buffers are nil")
            return
        }

        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(verticesBuffer, offset: 0, index: 0)

        if rotationParams != nil {
            rotationParams!.angle += rotationParams!.speed
            let rotationMatrix = matrix4x4_rotation(axis: rotationParams!.axis, angle: rotationParams!.angle)

            uniforms.modelMatrix = rotationMatrix
        }

        uniformsBuffer.contents().copyMemory(from: &uniforms, byteCount: MemoryLayout<Uniforms>.stride)
        encoder.setVertexBuffer(uniformsBuffer, offset: 0, index: 1)

        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

}
