import JavaScriptCore
import Metal

@available(macOS 13.0, *)
@objc protocol TriangleGeometryDescriptorProtocol {
    var vertex_buffer: GPUBuffer? { set get }
    var vertex_buffer_offset: Int { set get }
    var vertex_format: UInt { set get }
}

@available(macOS 13.0, *)
@objc public class TriangleGeometryDescriptor: NSObject, TriangleGeometryDescriptorProtocol {
    var descriptor: MTLAccelerationStructureTriangleGeometryDescriptor!
    
    init(descriptor: MTLAccelerationStructureTriangleGeometryDescriptor!) {
        self.descriptor = descriptor
    }
    
    var vertex_buffer: GPUBuffer? {
        set { descriptor.vertexBuffer = newValue?.buffer }
        get { return nil }
    }
    
    var vertex_buffer_offset: Int {
        set { descriptor.vertexBufferOffset = newValue }
        get { return descriptor.vertexBufferOffset }
    }
    
    var vertex_format: UInt {
        set { descriptor.vertexFormat = MTLAttributeFormat(rawValue: newValue) ?? .float3 }
        get { return descriptor.vertexFormat.rawValue }
    }
    
    var vertex_stride: Int {
        set { descriptor.vertexBufferOffset = newValue }
        get { return descriptor.vertexStride }
    }
    
    var index_buffer: GPUBuffer? {
        set { descriptor.indexBuffer = newValue?.buffer }
        get { return nil }
    }
    
    var index_buffer_offset: Int {
        set { descriptor.indexBufferOffset = newValue }
        get { return descriptor.indexBufferOffset }
    }
    
    var index_type: UInt {
        set { descriptor.indexType = MTLIndexType(rawValue: newValue) ?? .uint32 }
        get { return descriptor.indexType.rawValue }
    }
    
    var triangle_count: Int {
        set { descriptor.triangleCount = newValue }
        get { return descriptor.triangleCount }
    }
    
    var transformation_matrix_buffer: GPUBuffer? {
        set { descriptor.transformationMatrixBuffer = newValue?.buffer}
        get { return nil }
    }
    
    var transformation_matrix_offset: Int {
        set { descriptor.transformationMatrixBufferOffset = newValue }
        get { return descriptor.transformationMatrixBufferOffset }
    }
}

@objc public protocol AccelerationStructureDescriptor {
    var usage: UInt { get set }
}

@available(macOS 13.0, *)
@objc public class PrimitiveAccelerationStructureDescriptor: NSObject, AccelerationStructureDescriptor {
    var descriptor: MTLPrimitiveAccelerationStructureDescriptor!
    init(descriptor: MTLPrimitiveAccelerationStructureDescriptor) {
        self.descriptor = descriptor
    }
    
    var geometry_descriptors: JSValue? {
        set {
            let array = newValue?.toArray() as? [TriangleGeometryDescriptor]
            if array == nil { return }
            descriptor.geometryDescriptors = array!.map({ $0.descriptor })
        }
        get { return nil }
    }
    
    var motion_start_border_mode: UInt32 {
        set { descriptor.motionStartBorderMode = MTLMotionBorderMode(rawValue: newValue) ?? .clamp }
        get { return descriptor.motionStartBorderMode.rawValue }
    }
    
    var motion_end_border_mode: UInt32 {
        set { descriptor.motionEndBorderMode = MTLMotionBorderMode(rawValue: newValue) ?? .clamp }
        get { return descriptor.motionEndBorderMode.rawValue }
    }
    
    var motion_start_time: Float {
        set { descriptor.motionStartTime = newValue }
        get { return descriptor.motionStartTime }
    }
    
    var motion_end_time: Float {
        set { descriptor.motionEndTime = newValue }
        get { return descriptor.motionEndTime }
    }
    
    var motion_keyframe_count: Int {
        set { descriptor.motionKeyframeCount = newValue }
        get { return descriptor.motionKeyframeCount }
    }
    
    public var usage: UInt {
        set {
            var mask: MTLAccelerationStructureUsage = .init(rawValue: 0)
            if (newValue & 1) != 0 { mask.insert(.refit) }
            if (newValue & 2) != 0 { mask.insert(.preferFastBuild)}
            if (newValue & 4) != 0 { mask.insert(.extendedLimits)}
            descriptor.usage = mask
        }
        get {
            var mask: UInt = 0
            let usage = descriptor.usage
            if usage.contains(.refit) { mask |= 1 }
            if usage.contains(.preferFastBuild) { mask |= 2 }
            if usage.contains(.extendedLimits) { mask |= 4 }
            return mask
        }
    }
}


@available(macOS 13.0, *)
@objc public class AccelerationStructure: NSObject {
    var structure: MTLAccelerationStructure!
    init(structure: MTLAccelerationStructure!) {
        self.structure = structure
    }
    
    var size: Int {
        get { return structure.size }
    }
    
    var id: UInt64 {
        get { return structure.gpuResourceID._impl }
    }
}

@available(macOS 13.0, *)
@objc public class AccelerationStructureCommandEncoder: NSObject {
    var encoder: MTLAccelerationStructureCommandEncoder!
    
    public func build(_ structure: AccelerationStructure, _ descriptor: AccelerationStructureDescriptor, scratch_buffer: GPUBuffer, scratch_buffer_offset: Int) {
        
    }
}
