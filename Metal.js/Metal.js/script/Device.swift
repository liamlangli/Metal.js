//
//  File.swift
//  Metal.js
//
//  Created by Lang on 2022/7/19.
//

import Foundation
import JavaScriptCore
import Metal

@objc protocol GPUBufferProtocol : JSExport {
    func upload(_ data: JSValue) -> Void
}

@objc public class GPUBuffer : NSObject, GPUBufferProtocol{
    var buffer: MTLBuffer
    
    public init(_ buffer: MTLBuffer) {
        self.buffer = buffer
    }
    
    func upload(_ data: JSValue) {
        let context_ref = get_context().jsGlobalContextRef
        let ref = data.jsValueRef
        let type = JSValueGetTypedArrayType(context_ref, ref, nil)
        if type == kJSTypedArrayTypeNone {
            print("invalid buffer object")
            return
        }
        
        let size = JSObjectGetTypedArrayByteLength(context_ref, ref, nil)
        let ptr = JSObjectGetTypedArrayBytesPtr(context_ref, ref, nil)
        
        let gpu_ptr = UnsafeMutableRawPointer(buffer.contents()).bindMemory(to: UInt8.self, capacity: size)
        memcpy(gpu_ptr, ptr, size)
    }

}

@objc protocol DeviceProtocol : JSExport {
    func create_command_queue() -> CommandQueue
    func create_library(_ path: String) -> MTLLibrary?
    func create_library_default() -> MTLLibrary
    
    func create_buffer(_ size: Int, _ options: UInt) -> GPUBuffer;
}

@objc public class Device : NSObject, DeviceProtocol {
    let device: MTLDevice!
    public init(_ device: MTLDevice!) {
        self.device = device
    }
    
    func create_command_queue() -> CommandQueue {
        return CommandQueue(device)
    }
    
    func create_library(_ path: String) ->  MTLLibrary? {
        return nil
    }
    
    func create_library_default() -> MTLLibrary {
        return device.makeDefaultLibrary()!
    }
    
    func create_buffer(_ size: Int, _ options: UInt) -> GPUBuffer {
        let buffer = device.makeBuffer(length: size, options: MTLResourceOptions(rawValue: options))
        return GPUBuffer(buffer!)
    }
}

@objc protocol LibraryProtocol {
    func make_function(_ name: String) -> MTLFunction?
}
@objc public class Library : NSObject, LibraryProtocol {
    let library: MTLLibrary
    public init(_ library: MTLLibrary) {
        self.library = library
    }
    
    func make_function(_ name: String) -> Optional<MTLFunction> {
        return library.makeFunction(name: name)
    }
}

@objc public protocol CommandQueueProtocol {
    func create_command_buffer() -> CommandBuffer
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
