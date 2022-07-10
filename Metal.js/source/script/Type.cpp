//
//  Type.cpp
//  union_client
//
//  Created by Lang on 2022/7/10.
//

#include "Type.hpp"
#include "libplatform/libplatform.h"

namespace script {

using namespace v8;

class BufferAllocator : public ArrayBuffer::Allocator {
public:
    virtual void* Allocate(size_t length) {
        void* data = AllocateUninitialized(length);
        return data == NULL ? data : memset(data, 0, length);
    }
    
    virtual void* AllocateUninitialized(size_t length) {
        return malloc(length);
    }
    
    virtual void Free(void* data, size_t) { free(data); }
};

static BufferAllocator _allocator;
std::unique_ptr<Platform> _platform;
static Isolate* _isolate;
static Persistent<Context> _global;

Isolate* GetIsolate()
{
    if (_isolate) return _isolate;
    _platform = platform::NewDefaultPlatform();
    V8::InitializePlatform(_platform.get());
    V8::Initialize();
    
    Isolate::CreateParams create_params;
    create_params.array_buffer_allocator = &_allocator;
    _isolate = Isolate::New(create_params);
    
    Isolate::Scope isolate_scope(_isolate);
    HandleScope handle_scope(_isolate);
    Local<Context> context = Context::New(_isolate);
    _global.Reset(_isolate, context);
    return _isolate;
}

Persistent<Context>& GetGlobalContext()
{
    return _global;
}

void DisposeIsolate()
{
    _isolate->Dispose();
    V8::Dispose();
    V8::ShutdownPlatform();
    _platform.release();
}

Local<String> NewString(const char *str)
{
    EscapableHandleScope handle_scope(GetIsolate());
    return handle_scope.Escape(String::NewFromUtf8(_isolate, str, NewStringType::kNormal).ToLocalChecked());
}

}
