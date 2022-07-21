//
//  File.swift
//  Metal.js
//
//  Created by Lang on 2022/7/19.
//

import Foundation
import JavaScriptCore
import Metal
import QuartzCore
import MetalKit

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
    
    func create_library_from_source(_ source: String) -> MTLLibrary? {
        do {
            return try device.makeLibrary(source: source, options: nil)
        } catch let error {
            print("shader compile error: \(error.localizedDescription)")
        }
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

    public init(_ buffer: MTLCommandBuffer, _ back_buffer: BackBuffer) {
        self.encoder = buffer.makeRenderCommandEncoder(descriptor: back_buffer.desc)
    }
}

@objc public class CommandBuffer: NSObject, JSExport {
    let buffer: MTLCommandBuffer!
    public init(_ queue: MTLCommandQueue) {
        self.buffer = queue.makeCommandBuffer()
    }
    
    public func create_render_command_encoder(_ back_buffer: BackBuffer) -> RenderCommandEncoder {
        return RenderCommandEncoder(self.buffer, back_buffer)
    }
}

@objc public class Texture : NSObject, JSExport {
    public let texture: MTLTexture
    public init(_ texture: MTLTexture) {
        self.texture = texture
    }
}

@objc public protocol ColorProtocol : JSExport {
    var r: Double { get set }
    var g: Double { get set }
    var b: Double { get set }
    var a: Double { get set }
}

@objc public class Color : NSObject, ColorProtocol {
    public var r: Double { get { return color.red } set { color.red = newValue } }
    public var g: Double { get { return color.green } set { color.green = newValue } }
    public var b: Double { get { return color.blue } set { color.blue = newValue } }
    public var a: Double { get { return color.alpha } set { color.alpha = newValue } }
    
    public var color: MTLClearColor
    public init(_ color: MTLClearColor?) {
        self.color = color ?? MTLClearColor()
    }
}

@objc public protocol PassAttachmentDescriptorProtocol : JSExport {
    var texture: Texture? { get set }
    var level: Int { get set }
    var slice: Int { get set }
    var load_action: Int { get set }
    var store_action: Int { get set }
}

@objc public protocol PassColorAttachmentDescriptorProtocol : PassAttachmentDescriptorProtocol {
    var clear_color: Color { get set }
}

@objc public class PassColorAttachmentDescriptor: NSObject, PassColorAttachmentDescriptorProtocol {
    public var clear_color: Color {
        get { return Color(desc.clearColor) }
        set { desc.clearColor = newValue.color }
    }
    
    public var texture: Texture? {
        get {
            if self.desc.texture == nil {
                return nil
            } else {
                return Texture(desc.texture!)
            }
        }
        set {
            if let texture = newValue {
                desc.texture = texture.texture;
            }
        }
    }
    
    public var level: Int {
        get { return desc.level }
        set { desc.level = newValue }
    }
    
    public var slice: Int {
        get { return desc.slice }
        set { desc.slice = newValue }
    }
    
    public var load_action: Int {
        get { return Int(desc.loadAction.rawValue) }
        set { desc.loadAction = MTLLoadAction(rawValue: UInt(newValue)) ?? .dontCare }
    }
    
    public var store_action: Int {
        get { return Int(desc.storeAction.rawValue) }
        set { desc.storeAction = MTLStoreAction(rawValue: UInt(newValue)) ?? .dontCare }
    }
    
    public var desc: MTLRenderPassColorAttachmentDescriptor
    public override init() {
        desc = MTLRenderPassColorAttachmentDescriptor()
    }
}

@objc public protocol RenderPassDescriptor : JSExport {
    func color_attachment_at(index: Int) -> PassColorAttachmentDescriptor
}

@objc public protocol BackBufferProtocol : JSExport {
    var render_pass_descriptor: RenderPassDescriptor { get }
    var drawable: Drawable { get }
}

@objc public class BackBuffer: NSObject, JSExport {
    public let view: MTKView
    public let desc: MTLRenderPassDescriptor
    
    public init(_ view: MTKView, _ desc: MTLRenderPassDescriptor) {
        self.view = view;
        self.desc = desc;
    }
}

@objc public class Drawable: NSObject, JSExport {
    public init(_ drawable: CALayer) {
        
    }
}
