//
//  AppDelegate.h
//  union_client
//
//  Created by Lang on 2022/7/8.
//

#ifndef AppDelegate_h
#define AppDelegate_h

#define MTK_PRIVATE_IMPLEMENTATION
#include <AppKit/AppKit.hpp>
#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>

#include "MTKViewDelegate.hpp"

namespace client {
    
class AppDelegate : public NS::ApplicationDelegate {
public:
    ~AppDelegate();
    
    NS::Menu* createMenuBar();

    virtual void applicationWillFinishLaunching(NS::Notification* notification) override;
    virtual void applicationDidFinishLaunching(NS::Notification* notification) override;
    virtual bool applicationShouldTerminateAfterLastWindowClosed(NS::Application* sender) override;
private:
    NS::Window* _window;
    MTK::View* _view;
    MTL::Device* _device;
    MTKViewDelegate* _delegate;
};
    
}

#endif /* AppDelegate_h */
