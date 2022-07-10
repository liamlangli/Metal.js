//
//  main.cpp
//  union_client
//
//  Created by Lang on 2022/7/8.
//

#include <iostream>

#define NS_PRIVATE_IMPLEMENTATION
#define CA_PRIVATE_IMPLEMENTATION
#define MTL_PRIVATE_IMPLEMENTATION
#include <Foundation/Foundation.hpp>
#include <Metal/Metal.hpp>
#include <AppKit/AppKit.hpp>

#include "RenderEngine.hpp"
#include "AppDelegate.hpp"
#include "MTKViewDelegate.hpp"

#include "ScriptEngine.hpp"

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    NS::AutoreleasePool* pool = NS::AutoreleasePool::alloc()->init();

    client::AppDelegate delegate;

    script::ScriptEngine engine;
    engine.Register();
    engine.Test();
    
    NS::Application* app = NS::Application::sharedApplication();
    app->setDelegate(&delegate);
    app->run();

    pool->release();
    
    return 0;
}
