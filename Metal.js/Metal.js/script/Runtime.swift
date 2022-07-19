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

let create_device: @convention(block) () -> Device = {
    return Device(MTLCreateSystemDefaultDevice()!)
}

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
    register_console(context)

    context.setObject(Device.self, forKeyedSubscript: "Device" as NSString)
    context.setObject(create_device, forKeyedSubscript: "create_device" as NSString)
    context.setObject(request_swapchain_callback, forKeyedSubscript: "request_swapchain_callback" as NSString)
    context.setObject(cancal_swapchain_callback, forKeyedSubscript: "cancel_swapchain_callback" as NSString)
    
    context.exceptionHandler = { context, exception in
        if let exc = exception {
            print("JS Exception \(exc)")
        }
    }
}

public func runtime_evaluate(_ path: String) {
    if let url = Bundle.main.url(forResource: path, withExtension: "") {
        do {
            let source = try String(contentsOf: url, encoding: .utf8)
            print("[debug] evaluate script source\n\(source)")
            context.evaluateScript(source)
        } catch {
            print("unexpected error occured while reading file \(url.path)")
        }
    } else {
        print("file not found \(path)")
    }
}

var last_time: Double = 0.0
public func runtime_tick() {
    var delta = 0.016;
    let t = CACurrentMediaTime()
    if last_time != 0.0 { delta = t - last_time }
    last_time = t;
    
    for fn in tick_set {
        let time = JSValue(double: delta, in: context)!
        fn.call(withArguments: [time])
    }
}
