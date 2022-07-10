//
//  Device.cpp
//  union_client
//
//  Created by Lang on 2022/7/9.
//

#include "Device.hpp"
#include "Type.hpp"

namespace script {

Device::Device()
{
    
}

void create_device(const FunctionCallbackInfo<Value>& args)
{
    args.GetReturnValue().Set(NewString("device created"));
}

}
