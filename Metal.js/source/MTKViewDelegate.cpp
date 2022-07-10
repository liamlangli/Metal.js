//
//  MTKViewDelegate.cpp
//  union_client
//
//  Created by Lang on 2022/7/8.
//

#include "MTKViewDelegate.hpp"

namespace client {

MTKViewDelegate::MTKViewDelegate(MTL::Device* device)
    :MTK::ViewDelegate(),
    _engine(new RenderEngine(device))
{
}

MTKViewDelegate::~MTKViewDelegate()
{
    delete _engine;
}

void MTKViewDelegate::drawInMTKView(MTK::View *view)
{
    _engine->draw(view);
}

}
