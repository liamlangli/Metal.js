//
//  Console.swift
//  Metal.js
//
//  Created by Lang on 2022/7/19.
//

import Foundation
import JavaScriptCore

let println: @convention(block) (_ value: JSValue) -> Void = { value in
    print("\(value.toString() ?? "")")
};

public func register_console(_ context: JSContext) {
    context.setObject(println, forKeyedSubscript: "println" as NSString)
}
