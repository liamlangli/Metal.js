//
//  Console.swift
//  Metal.js
//
//  Created by Lang on 2022/7/19.
//

import Foundation
import JavaScriptCore

let println: @convention(block) (_ fmt: JSValue) -> Void = { fmt in
    print("\(fmt.toString() ?? "")")
};

public func register_console(_ context: JSContext) {
    context.setObject(println, forKeyedSubscript: "println" as NSString)
}
