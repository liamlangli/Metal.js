//
//  RenderEngine.hpp
//  union_client
//
//  Created by Lang on 2022/7/8.
//

#ifndef RenderEngine_hpp
#define RenderEngine_hpp

#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>

namespace client {

class RenderEngine {
public:
    RenderEngine(MTL::Device *device);
    ~RenderEngine();
    
    void draw(MTK::View *view);
private:
    MTL::Device* _device;
    MTL::CommandQueue* _commmand_queue;
};

}

#endif /* RenderEngine_hpp */
