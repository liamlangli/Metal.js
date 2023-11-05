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
import metalscript

public class MetalScriptRenderer: NSObject, MTKViewDelegate {
    public let device: MTLDevice
    public let command_queue: MTLCommandQueue
    let in_flight_semaphore = DispatchSemaphore(value: 3)

    public var back_buffer: BackBuffer? = nil
    let script_device: MetalScriptDevice

    init?(_ view: MTKView) {
        guard let metal_device = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device")
            return nil
        }

        self.device = metal_device
        self.command_queue = device.makeCommandQueue()!
        view.device = metal_device

        view.depthStencilPixelFormat = .depth32Float_stencil8
        view.colorPixelFormat = .bgra8Unorm_srgb
        view.sampleCount = 1

        script_device = MetalScriptDevice(device)
        super.init()
    }

    public func draw(in view: MTKView) {
        _ = in_flight_semaphore.wait(timeout: DispatchTime.distantFuture)
        if (view.currentDrawable == nil) {
            return
        }
        if (back_buffer == nil) {
            back_buffer = BackBuffer(view)
        }

        if let command_buffer = command_queue.makeCommandBuffer() {
            let semaphore = in_flight_semaphore
            command_buffer.addCompletedHandler { (_ command_buffer) -> Swift.Void in
                semaphore.signal()
            }

            back_buffer!.set_command_buffer(command_buffer)
            script_device.tick(back_buffer!)
        }
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}
