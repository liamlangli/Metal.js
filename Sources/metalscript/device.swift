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

@objc protocol GPUFenceProtocol: JSExport {
    var device: MetalScriptDevice { get }
    var label: String? { get set }
}

@objc public class GPUFence: NSObject, GPUFenceProtocol {
    var fence: MTLFence!
    public init(_ fence: MTLFence) {
        self.fence = fence
    }
    
    public var device: MetalScriptDevice {
        get { return MetalScriptDevice.shared }
    }
    
    public var label: String? {
        get { return fence.label }
        set { fence.label = newValue }
    }
}

@objc protocol GPUBufferProtocol : JSExport {
    func upload(_ data: JSValue) -> Void
}

@objc public class GPUBuffer : NSObject, GPUBufferProtocol{
    var buffer: MTLBuffer
    var device: MetalScriptDevice;

    public init(_ device: MetalScriptDevice, _ buffer: MTLBuffer) {
        self.buffer = buffer
        self.device = device
    }

    func upload(_ data: JSValue) {
        let context_ref = device.context.jsGlobalContextRef
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

@objc public class GPUTexture : NSObject, JSExport {
    public let texture: MTLTexture
    public init(_ texture: MTLTexture) {
        self.texture = texture
    }
}

@objc public class GPUProgram : NSObject, JSExport {
    let function: MTLFunction
    public init(_ function: MTLFunction) {
        self.function = function
    }
}

@objc protocol LibraryProtocol : JSExport {
    func create_function(_ name: String) -> GPUProgram?
}
@objc public class Library : NSObject, LibraryProtocol {
    public func create_function(_ name: String) -> GPUProgram? {
        if let program = library.makeFunction(name: name) {
            return GPUProgram(program)
        }
        return nil
    }

    let library: MTLLibrary
    public init(_ library: MTLLibrary) {
        self.library = library
    }
}

@objc protocol CommandQueueProtocol : JSExport {
    func create_command_buffer() -> CommandBuffer?
}

@objc public class CommandQueue: NSObject, CommandQueueProtocol {
    public func create_command_buffer() -> CommandBuffer? {
        if let buffer = queue.makeCommandBuffer() {
            return CommandBuffer(buffer)
        }
        return nil
    }

    let queue: MTLCommandQueue!
    public init(_ device: MTLDevice!) {
        queue = device.makeCommandQueue()
    }
}

@objc protocol RenderCommandEncoderProtocol : JSExport {
    var label: String { get set }

    func set_viewport(_ x: Double, _ y: Double, _ width: Double, _ height: Double, _ near: Double, _ far: Double) -> Void
    func set_cull_mode(_ mode: Int) -> Void
    func set_depth_clip_mode(_ mode: Int) -> Void
    func set_front_facing(_ facing: Int) -> Void
    func set_render_pipeline_state(_ pipeline_state: RenderPipelineState) -> Void
    func set_depth_stencil_state(_ depth_stencil_state: DepthStencilState) -> Void

    func push_debug_group(_ name: String) -> Void
    func pop_debug_group(_ name: String) -> Void

    func set_vertex_buffer(_ buffer: GPUBuffer, _ offset: Int, _ index: Int) -> Void
    func set_vertex_texture(_ texture: GPUTexture, _ index: Int) -> Void
    func set_fragment_buffer(_ buffer: GPUBuffer, _ offset: Int, _ index: Int) -> Void
    func set_fragment_texture(_ texture: GPUTexture, _ index: Int) -> Void

    func draw_primitive(_ type: Int, _ start: Int, _ count: Int) -> Void
    func draw_primitive(_ type: Int, _ start: Int, _ count: Int, _ instance_count: Int) -> Void
    func draw_primitive_indexed(_ type: Int, _ index_count: Int, _ index_type: Int, _ buffer: GPUBuffer, _ buffer_offset: Int) -> Void
    func draw_primitive_indexed(_ type: Int, _ index_count: Int, _ index_type: Int, _ buffer: GPUBuffer, _ buffer_offset: Int, _ instance_count: Int) -> Void

    // TODO indirect buffer draw
    func end_encoding() -> Void
}

@objc public class RenderCommandEncoder: NSObject, RenderCommandEncoderProtocol {
    public var label: String {
        get { return encoder.label ?? ""}
        set { encoder.label = newValue}
    }

    public func set_viewport(_ x: Double, _ y: Double, _ width: Double, _ height: Double, _ near: Double, _ far: Double) {
        encoder.setViewport(MTLViewport(originX: x, originY: y, width: width, height: height, znear: near, zfar: far))
    }

    public func set_cull_mode(_ mode: Int) {
        encoder.setCullMode(MTLCullMode(rawValue: UInt(mode))!)
    }

    public func set_depth_clip_mode(_ mode: Int) {
        encoder.setDepthClipMode(MTLDepthClipMode(rawValue: UInt(mode))!)
    }

    public func set_front_facing(_ facing: Int) {
        encoder.setFrontFacing(MTLWinding(rawValue: UInt(facing))!)
    }

    public func set_render_pipeline_state(_ pipeline_state: RenderPipelineState) {
        encoder.setRenderPipelineState(pipeline_state.state)
    }

    public func set_depth_stencil_state(_ depth_stencil_state: DepthStencilState) {
        encoder.setDepthStencilState(depth_stencil_state.state)
    }

    public func push_debug_group(_ name: String) {
        encoder.pushDebugGroup(name)
    }

    public func pop_debug_group(_ name: String) {
        encoder.popDebugGroup()
    }

    public func set_vertex_buffer(_ buffer: GPUBuffer, _ offset: Int, _ index: Int) {
        encoder.setVertexBuffer(buffer.buffer, offset: offset, index: index)
    }

    public func set_vertex_texture(_ texture: GPUTexture, _ index: Int) {
        encoder.setVertexTexture(texture.texture, index: index)
    }

    public func set_fragment_buffer(_ buffer: GPUBuffer, _ offset: Int, _ index: Int) {
        encoder.setFragmentBuffer(buffer.buffer, offset: offset, index: index)
    }

    public func set_fragment_texture(_ texture: GPUTexture, _ index: Int) {
        encoder.setFragmentTexture(texture.texture, index: index)
    }

    public func draw_primitive(_ type: Int, _ start: Int, _ count: Int) {
        encoder.drawPrimitives(type: MTLPrimitiveType(rawValue: UInt(type))!, vertexStart: start, vertexCount: count)
    }

    public func draw_primitive(_ type: Int, _ start: Int, _ count: Int, _ instance_count: Int) {
        encoder.drawPrimitives(type: MTLPrimitiveType(rawValue: UInt(type))!, vertexStart: start, vertexCount: count, instanceCount: instance_count)
    }

    public func draw_primitive_indexed(_ type: Int, _ index_count: Int, _ index_type: Int, _ buffer: GPUBuffer, _ buffer_offset: Int) {
        encoder.drawIndexedPrimitives(
            type: MTLPrimitiveType(rawValue: UInt(type))!,
            indexCount: index_count,
            indexType: MTLIndexType(rawValue: UInt(index_type))!,
            indexBuffer: buffer.buffer,
            indexBufferOffset: buffer_offset)
    }

    public func draw_primitive_indexed(_ type: Int, _ index_count: Int, _ index_type: Int, _ buffer: GPUBuffer, _ buffer_offset: Int, _ instance_count: Int) {
        encoder.drawIndexedPrimitives(
            type: MTLPrimitiveType(rawValue: UInt(type))!,
            indexCount: index_count,
            indexType: MTLIndexType(rawValue: UInt(index_type))!,
            indexBuffer: buffer.buffer,
            indexBufferOffset: buffer_offset,
            instanceCount: instance_count)
    }

    public func end_encoding() {
        encoder.endEncoding()
    }

    let encoder: MTLRenderCommandEncoder!

    public init(_ buffer: MTLCommandBuffer, _ desc: MTLRenderPassDescriptor) {
        self.encoder = buffer.makeRenderCommandEncoder(descriptor: desc)
    }
}

@objc protocol CommandBufferProtocol : JSExport {
    func create_render_command_encoder(_ desc: RenderPassDescriptor) -> RenderCommandEncoder?
    func present(_ drawable: Drawable) -> Void
    func commit() -> Void
}
@objc public class CommandBuffer: NSObject, CommandBufferProtocol {
    public func create_render_command_encoder(_ desc: RenderPassDescriptor) -> RenderCommandEncoder? {
        return RenderCommandEncoder(buffer, desc.desc)
    }
    
//    public func create_acceleration_structure_command_encoder(_ dest:  )

    public func present(_ drawable: Drawable) {
        buffer.present(drawable.drawable)
    }

    public func commit() {
        buffer.commit()
    }

    public var buffer: MTLCommandBuffer!
    public init(_ command_buffer: MTLCommandBuffer) {
        buffer = command_buffer
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

@objc protocol MetalScriptDeviceProtocol : JSExport {
    func create_command_queue() -> CommandQueue
    func create_library_from_source(_ source: String) -> Library?
    func create_buffer(_ size: Int, _ options: UInt) -> GPUBuffer
    func create_texture(_ desc: TextureDescriptor) -> GPUTexture?

    func create_render_pipeline_state(_ desc: RenderPipelineDescriptor) -> RenderPipelineState?
    func create_depth_stencil_state(_ desc: DepthStencilDescriptor) -> DepthStencilState?

    func create_texture_descriptor() -> TextureDescriptor
    func create_render_pipeline_descriptor() -> RenderPipelineDescriptor
    func create_depth_stencil_descriptor() -> DepthStencilDescriptor

    func request_swapchain_callback(_ value: JSValue) -> Void
    func cancel_swapchain_callback(_ value: JSValue) -> Void
    func load_script(_ url: String) -> Void
}

@objc public class MetalScriptDevice : NSObject, MetalScriptDeviceProtocol {
    private static var _instance: MetalScriptDevice!
    public static var shared: MetalScriptDevice {
        get {
            if _instance == nil {
                _instance = MetalScriptDevice(MTLCreateSystemDefaultDevice())
            }
            return _instance;
        }
    }
        
    public func create_command_queue() -> CommandQueue {
        return CommandQueue(device)
    }

    public func create_library_from_source(_ source: String) -> Library? {
        do {
            return Library(try device.makeLibrary(source: source, options: nil))
        } catch let error {
            print("shader compile error: \(error.localizedDescription)")
            return nil
        }
    }

    func create_library_default() -> MTLLibrary {
        return device.makeDefaultLibrary()!
    }

    func create_buffer(_ size: Int, _ options: UInt) -> GPUBuffer {
        let buffer = device.makeBuffer(length: size, options: MTLResourceOptions(rawValue: options))
        return GPUBuffer(self, buffer!)
    }

    public func create_texture(_ desc: TextureDescriptor) -> GPUTexture? {
        if let texture = device.makeTexture(descriptor: desc.desc) {
            return GPUTexture(texture)
        }
        return nil
    }

    public func create_render_pipeline_state(_ desc: RenderPipelineDescriptor) -> RenderPipelineState? {
        do {
            let state = try device.makeRenderPipelineState(descriptor: desc.desc)
            return RenderPipelineState(state)
        } catch let error {
            print("create_render_pipeline_state failed \(error.localizedDescription)")
            return nil
        }
    }

    public func create_depth_stencil_state(_ desc: DepthStencilDescriptor) -> DepthStencilState? {
        if let state = device.makeDepthStencilState(descriptor: desc.desc) {
            return DepthStencilState(state)
        }
        return nil
    }

    public func create_render_pipeline_descriptor() -> RenderPipelineDescriptor {
        return RenderPipelineDescriptor(nil)
    }

    public func create_depth_stencil_descriptor() -> DepthStencilDescriptor {
        return DepthStencilDescriptor(nil)
    }

    public func create_texture_descriptor() -> TextureDescriptor {
        return TextureDescriptor(nil)
    }

    public func request_swapchain_callback(_ value: JSValue) {
        tick_set.insert(value)
    }

    public func cancel_swapchain_callback(_ value: JSValue) {
        tick_set.remove(value)
    }

    public func tick(_ back_buffer: BackBuffer) {
        var delta = 0.016;
        let t = CACurrentMediaTime()
        if last_time != 0.0 { delta = t - last_time }
        last_time = t;

        for fn in tick_set {
            let time = JSValue(double: delta, in: context)!
            fn.call(withArguments: [time, back_buffer])
        }

        JSGarbageCollect(context.jsGlobalContextRef)
    }

    public func load_script(_ url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }

        print("try to load script \(url.absoluteString)")

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let script = String(data: data, encoding: .utf8) {
                print(script)
                self.context.evaluateScript(script)
            } else {
                print("Error: Failed to decode script data")
            }
        }

        task.resume()
    }

    public func load_script_async(_ url: String) async throws -> Void {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let script = String(data: data, encoding: .utf8) {
                context.evaluateScript(script)
            } else {
                print("Error: Failed to decode script data")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return
    }

    public func eval(_ script: String) {
        context.evaluateScript(script)
    }

    let device: MTLDevice!
    let context: JSContext!
    var tick_set = Set<JSValue>()
    var last_time: Double = 0.0

    public init(_ device: MTLDevice!) {
        self.device = device
        self.context = JSContext()

        context.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception \(exc)")
            }
        }
        
        context.setObject(metal_create_device, forKeyedSubscript: "metal_create_device" as NSString)
        context.setObject(MetalScriptDevice.self, forKeyedSubscript: "MetalScriptDevice" as NSString)
        context.setObject(Library.self, forKeyedSubscript: "Library" as NSString)
        context.setObject(CommandQueue.self, forKeyedSubscript: "CommandQueue" as NSString)
        context.setObject(CommandBuffer.self, forKeyedSubscript: "CommandBuffer" as NSString)
        context.setObject(RenderCommandEncoder.self, forKeyedSubscript: "RenderCommandEncoder" as NSString)
        context.setObject(GPUFence.self, forKeyedSubscript: "GPUFence" as NSString)
        context.setObject(GPUBuffer.self, forKeyedSubscript: "GPUBuffer" as NSString)
        context.setObject(GPUTexture.self, forKeyedSubscript: "GPUTexture" as NSString)
        context.setObject(GPUProgram.self, forKeyedSubscript: "GPUProgram" as NSString)
        context.setObject(Color.self, forKeyedSubscript: "Color" as NSString)

        context.setObject(Drawable.self, forKeyedSubscript: "Drawable" as NSString)
        context.setObject(BackBuffer.self, forKeyedSubscript: "BackBuffer" as NSString)

        context.setObject(RenderPassDescriptor.self, forKeyedSubscript: "RenderPassDescriptor" as NSString)
        context.setObject(RenderPassColorAttachmentDescriptor.self, forKeyedSubscript: "RenderPassColorAttachmentDescriptor" as NSString)
        context.setObject(RenderPassDepthAttachmentDescriptor.self, forKeyedSubscript: "RenderPassDepthAttachmentDescriptor" as NSString)
        context.setObject(RenderPassStencilAttachmentDescriptor.self, forKeyedSubscript: "RenderPassStencilAttachmentDescriptor" as NSString)

        context.setObject(RenderPipelineDescriptor.self, forKeyedSubscript: "RenderPipelineDescriptor" as NSString)
        context.setObject(RenderPipelineColorAttachmentDescriptor.self, forKeyedSubscript: "RenderPipelineColorAttachmentDescriptor" as NSString)
        context.setObject(RenderPipelineState.self, forKeyedSubscript: "RenderPipelineState" as NSString)
        context.setObject(DepthStencilState.self, forKeyedSubscript: "DepthStencilState" as NSString)

        context.setObject(ComputerPipelineState.self, forKeyedSubscript: "ComputerPipelineState" as NSString)

        context.setObject(RenderPassDepthAttachmentDescriptor.self, forKeyedSubscript: "RenderPassDepthAttachmentDescriptor" as NSString)
        context.setObject(RenderPassStencilAttachmentDescriptor.self, forKeyedSubscript: "RenderPassStencilAttachmentDescriptor" as NSString)

        context.setObject(CounterSampleBuffer.self, forKeyedSubscript: "CounterSampleBuffer" as NSString)
        context.setObject(ComputePassSampleBufferAttachmentDescriptor.self, forKeyedSubscript: "ComputePassSampleBufferAttachmentDescriptor" as NSString)
        context.setObject(ComputePassDescriptor.self, forKeyedSubscript: "ComputePassDescriptor" as NSString)
    }
}

let metal_create_device: @convention(block) () -> MetalScriptDevice = {
    return MetalScriptDevice.shared
}
