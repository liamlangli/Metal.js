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
    
    if value.isArray {
        print("is array")
        print("\((value.toArray() as! [Float])[0])")
    }
    
    if value.isObject {
        print("is object")
//        let dic = value.toObject() as! NSDictionary
//        dic
//        print("\(dic["127"])")
    }

};

public func register_console(_ context: JSContext) {
    context.setObject(println, forKeyedSubscript: "println" as NSString)
}
