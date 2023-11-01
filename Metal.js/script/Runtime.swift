//
//  Runtime.swift
//  Metal.js
//
//  Created by Lang on 2022/7/19.
//

import Foundation
import JavaScriptCore
import Metal
import QuartzCore
import MetalKit

var tick_set: Set<JSValue> = Set()
let request_swapchain_callback: @convention(block) (_ value: JSValue) -> Void = { value in
    if !tick_set.contains(where: { _value in _value.isEqual(to: value) }) {
        tick_set.insert(value)
    }
}

let cancal_swapchain_callback: @convention(block) (_ value: JSValue) -> Void = { value in
    if !tick_set.contains(where: { _value in _value.isEqual(to: value) }) {
        tick_set.remove(value)
    }
}

var context = JSContext()!
public func get_context() -> JSContext {
    return context
}

public func runtime_export() {
    context.setObject(request_swapchain_callback, forKeyedSubscript: "request_swapchain_callback" as NSString)
    context.setObject(cancal_swapchain_callback, forKeyedSubscript: "cancel_swapchain_callback" as NSString)

    register_device(context)
    register_console(context)
    register_render(context)

    context.exceptionHandler = { context, exception in
        if let exc = exception {
            print("JS Exception \(exc)")
        }
    }
}

public func runtime_initialize() {
    runtime_export()
    runtime_evaluate("http://unionengine.io/metal.js/index.js")
}

public func runtime_evaluate(_ url: String) {
    guard let url = URL(string: url) else {
        print("Invalid URL")
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        if let script = String(data: data, encoding: .utf8) {
            context.evaluateScript(script)
        } else {
            print("Error: Failed to decode script data")
        }
    }

    task.resume()
}

var last_time: Double = 0.0
public func runtime_tick(_ back_buffer: BackBuffer) {
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
