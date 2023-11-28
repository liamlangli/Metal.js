import Cocoa
import MetalKit
import metalscript

class MetalScriptViewController: NSViewController {

    var mtkView: MTKView!
    var renderer: MetalScriptRenderer!
    
    override func loadView() {
        self.view = mtkView   
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mtkView.isPaused = false
    }
    
    public func post_init() {
        mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        
        renderer = MetalScriptRenderer(mtkView)
        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = renderer
    }
    
    public func load_script(_ url: String) async {
        do {
            try await renderer.script_device.load_script_async(url)
        }
        catch let err {
            print(err)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    var controller: MetalScriptViewController!

    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1080, height: 720),
                          styleMask: [.titled, .closable, .resizable, .miniaturizable],
                          backing: .buffered,
                          defer: false)
        window.contentView = controller.view
        window.delegate = self
        
        window.title = "Metal Script Client"
        window.center()
        window.orderFrontRegardless()
        window.appearance = NSAppearance(named: .darkAqua)
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        return .terminateNow
    }

    func windowDidBecomeKey(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            window.level = .floating
        }
    }

    func windowDidResignKey(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            window.level = .normal
        }
    }
    
    public func load_script(_ url: String) async {
        do {
            try await self.controller.renderer.script_device.load_script_async(url)
        }
        catch let err {
            print(err)
        }
    }
}
