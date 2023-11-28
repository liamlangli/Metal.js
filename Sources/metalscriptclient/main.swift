import metalscript
import MetalKit
import ArgumentParser

struct ScriptArguments: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Run target script. remote script acceptable.")
    
    @Argument(help: "Source script url")
    public var url: String = "http://localhost:3000/index.js"
}

func main() {
    let url = ScriptArguments.parseOrExit().url;
    print("Launch Metal Script Client")
    let app = NSApplication.shared
    let delegate = AppDelegate()
    delegate.controller = MetalScriptViewController()
    delegate.controller.post_init()
    app.delegate = delegate
    Task {
        await delegate.controller.load_script(url)
    }
    app.run()
}

main()
