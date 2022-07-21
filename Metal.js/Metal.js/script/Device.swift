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

@objc protocol TextureDescriptorProtocol : JSExport {
    var type: Int { get set }
    var pixel_format: Int { get set }
    var width: Int { get set }
    var height: Int { get set }
    var depth: Int { get set }
    var minmap_level_count: Int { get set }
    var sample_count: Int { get set }
    var array_length: Int { get set }
    var option: Int { get set }
    var cpu_cache_mode: Int { get set }
    var storage_mode: Int { get set }
    var hazard_tracking_mode: Int { get set }
    var usage: Int { get set }
    var allow_gpu_optimized_contents: Bool { get set }
}
@objc public class TextureDescriptor : NSObject, TextureDescriptorProtocol {
    public var type: Int {
        get { return Int(desc.textureType.rawValue) }
        set { desc.textureType = MTLTextureType(rawValue: UInt(newValue)) ?? .type2D }
    }
    
    public var pixel_format: Int {
        get { return Int(desc.pixelFormat.rawValue) }
        set { desc.pixelFormat = MTLPixelFormat(rawValue: UInt(newValue)) ?? .rgba8Unorm }
    }
    
    public var width: Int {
        get { return desc.width }
        set { desc.width = newValue }
    }
    
    public var height: Int {
        get { return desc.width }
        set { desc.height = newValue }
    }
    
    public var depth: Int {
        get { return desc.depth }
        set { desc.depth = newValue }
    }
    
    public var minmap_level_count: Int {
        get { return desc.mipmapLevelCount }
        set { desc.mipmapLevelCount = newValue }
    }
    
    public var sample_count: Int {
        get { return desc.sampleCount }
        set { desc.sampleCount = newValue }
    }
    
    public var array_length: Int {
        get { return desc.arrayLength }
        set {desc.arrayLength = newValue }
    }
    
    public var option: Int {
        get { return Int(desc.resourceOptions.rawValue) }
        set { desc.resourceOptions = MTLResourceOptions(rawValue: UInt(newValue)) }
    }
    
    public var cpu_cache_mode: Int {
        get { return Int(desc.cpuCacheMode.rawValue) }
        set { desc.cpuCacheMode = MTLCPUCacheMode(rawValue: UInt(newValue))! }
    }
    
    public var storage_mode: Int {
        get { return Int(desc.storageMode.rawValue) }
        set { desc.storageMode = MTLStorageMode(rawValue: UInt(newValue))! }
    }
    
    public var hazard_tracking_mode: Int {
        get { return Int(desc.hazardTrackingMode.rawValue) }
        set { desc.hazardTrackingMode = MTLHazardTrackingMode(rawValue: UInt(newValue))! }
    }
    
    public var usage: Int {
        get { return Int(desc.usage.rawValue) }
        set { desc.usage = MTLTextureUsage(rawValue: UInt(newValue)) }
    }
    
    var allow_gpu_optimized_contents: Bool {
        get { return desc.allowGPUOptimizedContents }
        set { desc.allowGPUOptimizedContents = newValue }
    }
    
    var desc: MTLTextureDescriptor
    public init(_ desc: MTLTextureDescriptor?) {
        self.desc = desc ?? MTLTextureDescriptor()
    }
}

@objc protocol DeviceProtocol : JSExport {
    func create_command_queue() -> CommandQueue
    func create_library(_ path: String) -> MTLLibrary?
    func create_library_default() -> MTLLibrary
    
    func create_buffer(_ size: Int, _ options: UInt) -> GPUBuffer
    func create_texture(_ desc: TextureDescriptor) -> GPUTexture
//    func create_depth_stencil_descriptor() -> Depth
    
    func prefer_frame_per_second(_ fps: Double) -> Void
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

@objc public class GPUTexture : NSObject, JSExport {
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

@objc public class GPUProgram : NSObject, JSExport {
    let function: MTLFunction
    public init(_ function: MTLFunction) {
        self.function = function
    }
}

let create_device: @convention(block) () -> Device = {
    return Device(MTLCreateSystemDefaultDevice()!)
}

public func register_device(_ context: JSContext) {
    context.setObject(create_device, forKeyedSubscript: "create_device" as NSString)
    
    context.setObject(Device.self, forKeyedSubscript: "Device" as NSString)
}
