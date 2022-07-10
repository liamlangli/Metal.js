//
//  ScriptEngine.cpp
//  union_client
//
//  Created by Lang on 2022/7/8.
//

#include "ScriptEngine.hpp"

#include "Device.hpp"
#include "Type.hpp"

namespace script {

ScriptEngine::ScriptEngine() {
    Isolate* isolate = GetIsolate();
    Isolate::Scope isolate_scope(isolate);
    HandleScope handle_scope(isolate);
}

void ScriptEngine::Test()
{
    Isolate* isolate = GetIsolate();
    Isolate::Scope isolate_scope(isolate);
    HandleScope handle_scope(isolate);

    Local<Context> context = Local<Context>::New(isolate, GetGlobalContext());
    Local<String> source = String::NewFromUtf8(isolate, "create_device()").ToLocalChecked();
    Local<Script> script = Script::Compile(context, source).ToLocalChecked();

    // Run the script to get the result.
    Local<Value> result = script->Run(context).ToLocalChecked();
    // Convert the result to an UTF8 string and print it.
    String::Utf8Value utf8(isolate, result);
    printf("%s\n", *utf8);
}

void ScriptEngine::Register()
{
    Isolate* isolate = GetIsolate();
    Isolate::Scope isolate_scope(isolate);
    HandleScope handle_scope(isolate);

    Local<Context> context = Local<Context>::New(isolate, GetGlobalContext());
    Local<FunctionTemplate> func_templ = FunctionTemplate::New(isolate, create_device);
    Local<Function> func = func_templ->GetFunction(context).ToLocalChecked();
    context->Global()->Set(context, NewString("create_device"), func).FromJust();
}

ScriptEngine::~ScriptEngine() {
}

}
