//
//  File.swift
//  Metal.js
//
//  Created by Lang on 2022/7/19.
//

import Foundation
import JavaScriptCore
import Metal

@objc protocol DeviceProtocol : JSExport {
    func create_command_queue() -> CommandQueue;
}

@objc public class Device : NSObject, DeviceProtocol {
    let device: MTLDevice!
    public init(_ device: MTLDevice!) {
        self.device = device
    }
    
    func create_command_queue() -> CommandQueue {
        return CommandQueue(device)
    }
}


@objc public protocol CommandQueueProtocol {
    func create_command_buffer() -> CommandBuffer;
}

@objc public class CommandQueue: NSObject, CommandQueueProtocol {
    let queue: MTLCommandQueue!
    public init(_ device: MTLDevice!) {
        queue = device.makeCommandQueue()
    }
    
    public func create_command_buffer() -> CommandBuffer {
        return CommandBuffer(queue)
    }
}

@objc public class RenderCommandEncoder: NSObject, JSExport {
    let encoder: MTLRenderCommandEncoder!
    public init(_ buffer: MTLCommandBuffer, desc: MTLRenderPassDescriptor) {
        self.encoder = buffer.makeRenderCommandEncoder(descriptor: desc)
    }
}

@objc public class CommandBuffer: NSObject, JSExport {
    let buffer: MTLCommandBuffer!
    public init(_ queue: MTLCommandQueue) {
        self.buffer = queue.makeCommandBuffer()
    }
    
    public func create_render_command_encoder() {
        
    }
}
