//
//  AppDelegate.cpp
//  union_client
//
//  Created by Lang on 2022/7/8.
//

#include "AppDelegate.hpp"

namespace client
{

AppDelegate::~AppDelegate()
{
    _view->release();
    _window->release();
    _device->release();
    delete _delegate;
}

NS::Menu *AppDelegate::createMenuBar()
{
    using NS::StringEncoding::UTF8StringEncoding;
    
    NS::Menu *pMainMenu = NS::Menu::alloc()->init();
    NS::MenuItem *pAppMenuItem = NS::MenuItem::alloc()->init();
    NS::Menu *pAppMenu = NS::Menu::alloc()->init(NS::String::string("Appname", UTF8StringEncoding));
    
    NS::String *appName = NS::RunningApplication::currentApplication()->localizedName();
    NS::String *quitItemName = NS::String::string("Quit ", UTF8StringEncoding)->stringByAppendingString(appName);
    SEL quitCb = NS::MenuItem::registerActionCallback("appQuit", [](void *, SEL, const NS::Object *pSender) {
        auto pApp = NS::Application::sharedApplication();
        pApp->terminate(pSender);
    });
    
    NS::MenuItem *pAppQuitItem = pAppMenu->addItem(quitItemName, quitCb, NS::String::string("q", UTF8StringEncoding));
    pAppQuitItem->setKeyEquivalentModifierMask(NS::EventModifierFlagCommand);
    pAppMenuItem->setSubmenu(pAppMenu);
    
    NS::MenuItem *pWindowMenuItem = NS::MenuItem::alloc()->init();
    NS::Menu *pWindowMenu = NS::Menu::alloc()->init(NS::String::string("Window", UTF8StringEncoding));
    
    SEL closeWindowCb = NS::MenuItem::registerActionCallback("windowClose", [](void *, SEL, const NS::Object *)
                                                             {
        auto pApp = NS::Application::sharedApplication();
        pApp->windows()->object< NS::Window >(0)->close(); });
    NS::MenuItem *pCloseWindowItem = pWindowMenu->addItem(NS::String::string("Close Window", UTF8StringEncoding), closeWindowCb, NS::String::string("w", UTF8StringEncoding));
    pCloseWindowItem->setKeyEquivalentModifierMask(NS::EventModifierFlagCommand);
    
    pWindowMenuItem->setSubmenu(pWindowMenu);
    
    pMainMenu->addItem(pAppMenuItem);
    pMainMenu->addItem(pWindowMenuItem);
    
    pAppMenuItem->release();
    pWindowMenuItem->release();
    pAppMenu->release();
    pWindowMenu->release();
    
    return pMainMenu->autorelease();
}

void AppDelegate::applicationWillFinishLaunching(NS::Notification *notification)
{
    NS::Menu *pMenu = createMenuBar();
    NS::Application *pApp = reinterpret_cast<NS::Application *>(notification->object());
    pApp->setMainMenu(pMenu);
    pApp->setActivationPolicy(NS::ActivationPolicy::ActivationPolicyRegular);
}

void AppDelegate::applicationDidFinishLaunching(NS::Notification *notification)
{
    CGRect frame = (CGRect){{100.0, 100.0}, {1080.0, 720.0}};
    
    _window = NS::Window::alloc()->init(
                                        frame,
                                        NS::WindowStyleMaskTitled |
                                        NS::WindowStyleMaskClosable |
                                        NS::WindowStyleMaskMiniaturizable |
                                        NS::WindowStyleMaskResizable,
                                        NS::BackingStoreBuffered,
                                        false);
    
    _device = MTL::CreateSystemDefaultDevice();
    
    _view = MTK::View::alloc()->init(frame, _device);
    _view->setColorPixelFormat(MTL::PixelFormat::PixelFormatBGRA8Unorm_sRGB);
    _view->setClearColor(MTL::ClearColor::Make(1.0, 0.0, 0.0, 1.0));
    
    _delegate = new MTKViewDelegate(_device);
    _view->setDelegate(_delegate);
    
    _window->setContentView(_view);
    _window->setTitle(NS::String::string("Metal.js", NS::StringEncoding::UTF8StringEncoding));
    
    _window->makeKeyAndOrderFront(nullptr);
    
    NS::Application *pApp = reinterpret_cast<NS::Application *>(notification->object());
    pApp->activateIgnoringOtherApps(true);
}

bool AppDelegate::applicationShouldTerminateAfterLastWindowClosed(NS::Application *sender)
{
    return true;
}

}
