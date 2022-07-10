//
//  Type.hpp
//  union_client
//
//  Created by Lang on 2022/7/10.
//

#ifndef Type_hpp
#define Type_hpp

#include "ScriptPort.h"

namespace script {

using namespace v8;

Isolate* GetIsolate();
void DisposeIsolate();
Persistent<Context>& GetGlobalContext();

Local<String> NewString(const char *str);

}

#endif /* Type_hpp */
