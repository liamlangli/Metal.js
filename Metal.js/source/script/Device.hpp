//
//  Device.hpp
//  union_client
//
//  Created by Lang on 2022/7/9.
//

#ifndef Device_hpp
#define Device_hpp

#include "ScriptPort.h"

namespace script {

using namespace v8;

class Device {
public:
    Device();
    ~Device();
};

void create_device(const FunctionCallbackInfo<Value>& args);

}

#endif /* Device_hpp */
