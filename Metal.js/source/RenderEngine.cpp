//
//  RenderEngine.cpp
//  union_client
//
//  Created by Lang on 2022/7/8.
//

#include "RenderEngine.hpp"

namespace client {

RenderEngine::RenderEngine(MTL::Device* device)
:_device(device)
{
    _commmand_queue = _device->newCommandQueue();
}

RenderEngine::~RenderEngine()
{
    _commmand_queue->release();
    _device->release();
}

void RenderEngine::draw(MTK::View *view)
{
    NS::AutoreleasePool* pool = NS::AutoreleasePool::alloc()->init();
    
    MTL::CommandBuffer* cmd = _commmand_queue->commandBuffer();
    MTL::RenderPassDescriptor* render_desc = view->currentRenderPassDescriptor();

    render_desc->colorAttachments()->object(0)->setClearColor(MTL::ClearColor(.3, .4, .5, 1.));
    MTL::RenderCommandEncoder* encoder = cmd->renderCommandEncoder(render_desc);
    
    encoder->endEncoding();
    
    cmd->presentDrawable(view->currentDrawable());
    cmd->commit();
    
    pool->release();
}

}
