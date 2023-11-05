import Cocoa
import MetalKit
import metalscript

class MetalScriptViewController: NSViewController {

    var mtkView: MTKView!
    var renderer: MetalScriptRenderer!

    override func loadView() {
        mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        self.view = mtkView

        mtkView.enableSetNeedsDisplay = true
        mtkView.isPaused = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let renderer = MetalScriptRenderer(mtkView) else {
            print("Renderer cannot be initialized")
            return
        }
        self.renderer = renderer
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    var controller: MetalScriptViewController!

    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1080, height: 720),
                          styleMask: [.titled, .closable, .resizable],
                          backing: .buffered,
                          defer: false)
        window.title = "Metal Script Client"
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.appearance = NSAppearance(named: .darkAqua)

        controller = MetalScriptViewController()
        window.contentView = controller.view
        window.delegate = self
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
}