//
//  Renderer.swift
//  Metal.js
//
//  Created by Lang on 2022/7/19.
//

// Our platform independent renderer class

import Metal
import MetalKit
import simd

class Renderer: NSObject, MTKViewDelegate {
    public let device: MTLDevice
    public let command_queue: MTLCommandQueue
    let in_flight_semaphore = DispatchSemaphore(value: 3)
    
    public let back_buffer: BackBuffer
    init?(_ view: MTKView) {
        self.device = view.device!
        self.command_queue = device.makeCommandQueue()!
        
        view.depthStencilPixelFormat = .depth32Float_stencil8
        view.colorPixelFormat = .bgra8Unorm_srgb
        view.sampleCount = 1
        
        back_buffer = BackBuffer(view)
        super.init()
    }

    func draw(in view: MTKView) {
        _ = in_flight_semaphore.wait(timeout: DispatchTime.distantFuture)
    
        if let command_buffer = command_queue.makeCommandBuffer() {
            let semaphore = in_flight_semaphore
            command_buffer.addCompletedHandler { (_ command_buffer) -> Swift.Void in
                semaphore.signal()
            }

            back_buffer.set_command_buffer(command_buffer)
            runtime_tick(back_buffer)
        }

    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}
