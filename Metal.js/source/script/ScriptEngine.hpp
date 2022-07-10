//
//  ScriptEngine.hpp
//  union_client
//
//  Created by Lang on 2022/7/8.
//

#ifndef ScriptEngine_hpp
#define ScriptEngine_hpp

#include "ScriptPort.h"

namespace script {
using namespace v8;

class ScriptEngine {
public:
    ScriptEngine();
    ~ScriptEngine();
    
    void Test();
    void Register();
};

}

#endif /* ScriptEngine_hpp */
