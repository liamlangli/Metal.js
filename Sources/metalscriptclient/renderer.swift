import MetalKit
import simd
import metalscript

public class MetalScriptRenderer: NSObject, MTKViewDelegate {
    public let device: MTLDevice
    public var viewport: MTLViewport!
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
        view.sampleCount = 1
        view.preferredFramesPerSecond = 60

        script_device = MetalScriptDevice.shared
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
            
            let desc = view.currentRenderPassDescriptor!;
            desc.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
            desc.colorAttachments[0].loadAction = .clear
            desc.colorAttachments[0].storeAction = .store

            let encoder = command_buffer.makeRenderCommandEncoder(descriptor: desc)!
            encoder.setViewport(viewport)
            encoder.endEncoding()
            
            back_buffer!.set_command_buffer(command_buffer)
            script_device.tick(back_buffer!)

            command_buffer.present(view.currentDrawable!)
            command_buffer.commit()
        }
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewport = MTLViewport(originX: 0, originY: 0, width: size.width, height: size.height, znear: -1, zfar: 1)   
    }
}
