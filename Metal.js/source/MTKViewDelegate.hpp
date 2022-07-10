//
//  MTKViewDelegate.hpp
//  union_client
//
//  Created by Lang on 2022/7/8.
//

#ifndef MTKViewDelegate_hpp
#define MTKViewDelegate_hpp

#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>

#include "RenderEngine.hpp"

namespace client {

class MTKViewDelegate: public MTK::ViewDelegate {
public:
    MTKViewDelegate(MTL::Device* device);
    virtual ~MTKViewDelegate() override;
    virtual void drawInMTKView(MTK::View *view) override;
private:
    RenderEngine* _engine;
};

}

#endif /* MTKViewDelegate_hpp */
