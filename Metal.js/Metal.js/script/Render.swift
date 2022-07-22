//
//  Render.swift
//  Metal.js
//
//  Created by Lang on 2022/7/21.
//

import Foundation
import JavaScriptCore
import MetalKit

@objc protocol RenderPipelineColorAttachmentProtocol : JSExport {
    var pixel_format: Int { get set }
    var blend_enable: Bool { get set }

    var src_rgb_blend_factor: Int { get set }
    var src_alpha_blend_factor: Int { get set }

    var dst_rgb_blend_factor: Int { get set }
    var dst_alpha_blend_factor: Int { get set }

    var rgb_blend_operation: Int { get set }
    var alpha_blend_operation: Int { get set }
}

@objc public class RenderPipelineColorAttachmentDescriptor : NSObject, RenderPipelineColorAttachmentProtocol {

    public var pixel_format: Int {
        get { return Int(desc.pixelFormat.rawValue) }
        set { desc.pixelFormat = MTLPixelFormat(rawValue: UInt(newValue))! }
    }
    
    public var blend_enable: Bool {
        get { return desc.isBlendingEnabled }
        set { desc.isBlendingEnabled = newValue }
    }
    
    public var src_rgb_blend_factor: Int {
        get { return Int(desc.sourceRGBBlendFactor.rawValue) }
        set { desc.sourceRGBBlendFactor = MTLBlendFactor(rawValue: UInt(newValue))! }
    }
    
    public var src_alpha_blend_factor: Int {
        get { return Int(desc.sourceAlphaBlendFactor.rawValue) }
        set { desc.sourceAlphaBlendFactor = MTLBlendFactor(rawValue: UInt(newValue))! }
    }
    
    public var dst_rgb_blend_factor: Int {
        get { return Int(desc.destinationRGBBlendFactor.rawValue) }
        set { desc.destinationRGBBlendFactor = MTLBlendFactor(rawValue: UInt(newValue))! }
    }
    
    public var dst_alpha_blend_factor: Int {
        get { return Int(desc.destinationAlphaBlendFactor.rawValue) }
        set { desc.destinationAlphaBlendFactor = MTLBlendFactor(rawValue: UInt(newValue))! }
    }
    
    public var rgb_blend_operation: Int {
        get { return Int(desc.rgbBlendOperation.rawValue) }
        set { desc.rgbBlendOperation = MTLBlendOperation(rawValue: UInt(newValue))! }
    }
    
    public var alpha_blend_operation: Int {
        get { return Int(desc.alphaBlendOperation.rawValue) }
        set { desc.alphaBlendOperation = MTLBlendOperation(rawValue: UInt(newValue))! }
    }
    
    var desc: MTLRenderPipelineColorAttachmentDescriptor
    public init(_ desc: RenderPipelineDescriptor, _ slot: Int) {
        self.desc = desc.desc.colorAttachments[slot]
    }
}

@objc protocol DepthStencilDescriptorProtocol : JSExport {
    var depth_write: Bool { get set }
    var compare_function: Int { get set }
}
@objc public class DepthStencilDescriptor : NSObject, DepthStencilDescriptorProtocol {
    public var depth_write: Bool {
        get { return desc.isDepthWriteEnabled }
        set { desc.isDepthWriteEnabled = newValue }
    }
    
    public var compare_function: Int {
        get { return Int(desc.depthCompareFunction.rawValue) }
        set { desc.depthCompareFunction = MTLCompareFunction(rawValue: UInt(newValue))! }
    }
    
    let desc: MTLDepthStencilDescriptor
    public init(_ desc: MTLDepthStencilDescriptor?) {
        self.desc = desc ?? MTLDepthStencilDescriptor()
    }
}

@objc protocol RenderPipelineDescriptorProtocol : JSExport {
    var label: String { get set }
    var sample_count: Int { get set }
    var vertex_function: GPUProgram? { get set }
    var fragment_function: GPUProgram? { get set }
    var depth_attachment_pixel_format: Int { get set }
    var stencil_attachment_pixel_format: Int { get set }
    func color_attachment_at(_ index: Int) -> RenderPipelineColorAttachmentDescriptor
}

@objc public class RenderPipelineDescriptor : NSObject, RenderPipelineDescriptorProtocol {
    public var label: String {
        get { return desc.label ?? "" }
        set { desc.label = newValue }
    }
    
    public var sample_count: Int {
        get { return desc.sampleCount }
        set { desc.sampleCount = newValue }
    }
    
    public var vertex_function: GPUProgram? {
        get {
            if let function = desc.vertexFunction {
                return GPUProgram(function)
            } else {
                return nil
            }
        }
        set {
            if let program = newValue {
                desc.vertexFunction = program.function
            }
        }
    }
    
    public var fragment_function: GPUProgram? {
        get {
            if let function = desc.fragmentFunction {
                return GPUProgram(function)
            } else {
                return nil
            }
        }
        set {
            if let program = newValue {
                desc.fragmentFunction = program.function
            }
        }
    }
    
    public func color_attachment_at(_ index: Int) -> RenderPipelineColorAttachmentDescriptor {
        return RenderPipelineColorAttachmentDescriptor(self, index)
    }
    
    public var depth_attachment_pixel_format: Int {
        get { return Int(desc.depthAttachmentPixelFormat.rawValue) }
        set { desc.depthAttachmentPixelFormat = MTLPixelFormat(rawValue: UInt(newValue)) ?? .depth32Float_stencil8 }
    }
    
    public var stencil_attachment_pixel_format: Int {
        get { return Int(desc.stencilAttachmentPixelFormat.rawValue) }
        set { desc.depthAttachmentPixelFormat = MTLPixelFormat(rawValue: UInt(newValue)) ?? .depth32Float_stencil8 }
    }
    
    let desc: MTLRenderPipelineDescriptor
    public init(_ desc: MTLRenderPipelineDescriptor?) {
        self.desc = desc ?? MTLRenderPipelineDescriptor()
    }
}

@objc public class RenderPipelineState : NSObject, JSExport {
    let state: MTLRenderPipelineState
    public init(_ state: MTLRenderPipelineState) {
        self.state = state
    }
}

@objc public class DepthStencilState : NSObject, JSExport {
    let state: MTLDepthStencilState
    public init(_ state: MTLDepthStencilState) {
        self.state = state
    }
}

@objc protocol ComputePipelineProtocol : JSExport {
    
}

@objc public class ComputerPipelineState : NSObject, JSExport {
    let state: MTLComputePipelineState
    public init(_ state: MTLComputePipelineState) {
        self.state = state
    }
}

@objc protocol PassAttachmentProtocol : JSExport {
    var texture: GPUTexture? { get set }
    var level: Int { get set }
    var slice: Int { get set }
    var load_action: Int { get set }
    var store_action: Int { get set }
}

@objc public class RenderPassAttachmentDescriptor: NSObject, PassAttachmentProtocol {
    public var texture: GPUTexture? {
        get {
            if self.desc.texture == nil {
                return nil
            } else {
                return GPUTexture(desc.texture!)
            }
        }
        set {
            if let texture = newValue {
                desc.texture = texture.texture
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
    
    public var desc: MTLRenderPassAttachmentDescriptor
    
    public init(_ desc: MTLRenderPassAttachmentDescriptor) {
        self.desc = desc
    }
}

@objc protocol RenderPassColorAttachmentProtocol : JSExport {
    var clear_color: Color { get set }
}

@objc public class RenderPassColorAttachmentDescriptor : RenderPassAttachmentDescriptor, RenderPassColorAttachmentProtocol {

    public var clear_color: Color {
        get { return Color(color_desc.clearColor) }
        set { color_desc.clearColor = newValue.color }
    }
    
    public let color_desc: MTLRenderPassColorAttachmentDescriptor
    public init(_ desc: MTLRenderPassColorAttachmentDescriptor) {
        self.color_desc = desc
        super.init(desc)
    }
}

@objc protocol RenderPassDepthAttachmentProtocol : JSExport {
    var clear_depth: Double { get set }
}
@objc public class RenderPassDepthAttachmentDescriptor: RenderPassAttachmentDescriptor, RenderPassDepthAttachmentProtocol {

    public var clear_depth: Double {
        get { return depth_desc.clearDepth }
        set { depth_desc.clearDepth = newValue }
    }
    
    public let depth_desc: MTLRenderPassDepthAttachmentDescriptor
    public init(_ desc: MTLRenderPassDepthAttachmentDescriptor) {
        self.depth_desc = desc
        super.init(desc)
    }
}

@objc protocol RenderPassStencilAttachmentProtocol : JSExport {
    var clear_stencil: UInt { get set }
}
@objc public class RenderPassStencilAttachmentDescriptor: RenderPassAttachmentDescriptor, RenderPassStencilAttachmentProtocol {
    
    public var clear_stencil: UInt {
        get { return UInt(stencil_desc.clearStencil) }
        set { stencil_desc.clearStencil = UInt32(newValue) }
    }
    
    public let stencil_desc: MTLRenderPassStencilAttachmentDescriptor
    public init(_ desc: MTLRenderPassStencilAttachmentDescriptor) {
        self.stencil_desc = desc
        super.init(desc)
    }
}

@objc protocol RenderPassDescriptorProtocol : JSExport {
    func color_attachment_at(_ index: Int) -> RenderPassColorAttachmentDescriptor
    var depth_attachment: RenderPassDepthAttachmentDescriptor { get }
    var stencil_attachment: RenderPassStencilAttachmentDescriptor { get }
}

@objc public class RenderPassDescriptor : NSObject, RenderPassDescriptorProtocol {

    public func color_attachment_at(_ index: Int) -> RenderPassColorAttachmentDescriptor {
        return RenderPassColorAttachmentDescriptor(desc.colorAttachments[index])
    }
    
    public var depth_attachment: RenderPassDepthAttachmentDescriptor {
        get { return RenderPassDepthAttachmentDescriptor(desc.depthAttachment) }
    }
    
    public var stencil_attachment: RenderPassStencilAttachmentDescriptor {
        get { return RenderPassStencilAttachmentDescriptor(desc.stencilAttachment) }
    }
    
    public var desc: MTLRenderPassDescriptor
    public init(_ desc: MTLRenderPassDescriptor?) {
        self.desc = desc ?? MTLRenderPassDescriptor()
    }
}

@objc protocol BackBufferProtocol : JSExport {
    var render_pass_descriptor: RenderPassDescriptor { get }
    var drawable: Drawable? { get }
}

@objc public class BackBuffer: NSObject, BackBufferProtocol {
    public var render_pass_descriptor: RenderPassDescriptor {
        get { RenderPassDescriptor(desc) }
    }
    
    public var drawable: Drawable? {
        get {
            if let drawable = view.currentDrawable {
                return Drawable(drawable)
            }
            return nil
        }
    }
    
    public let view: MTKView
    public let desc: MTLRenderPassDescriptor
    
    public init(_ view: MTKView, _ desc: MTLRenderPassDescriptor) {
        self.view = view
        self.desc = desc
    }
}

@objc public class Drawable: NSObject, JSExport {
    let drawable: CAMetalDrawable
    public init(_ drawable: CAMetalDrawable) {
        self.drawable = drawable
    }
}

public func register_render(_ context: JSContext) {
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
}
