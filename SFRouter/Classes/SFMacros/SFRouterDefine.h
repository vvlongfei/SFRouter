//
//  SFRouterMacros.h
//  SFRouter
//
//  Created by longfei on 2020/8/11.
//

#ifndef SFRouterDefine_h
#define SFRouterDefine_h

#import "SFRouterPrivate.h"

extern void openPage(id sender, UIViewController *pageVC);
extern Class classForRouterKey(NSString *routerKey);

// 注册页面
#define SFRouterRegisterPage(RouterTip, RouterKey, ...) \
SFRouterWriteInfo(0, 0, RouterTip, RouterKey, UIViewController *, ##__VA_ARGS__)\
SFRouter_C_Function(Class, get_, RouterKey ## _class) { \
    return classForRouterKey(@metamacro_stringify(RouterKey)); \
}\
SFRouter_C_Function(UIViewController *, open_, RouterKey ## _page, (id)sender, ##__VA_ARGS__) { \
    Class PageClassName = classForRouterKey(@metamacro_stringify(RouterKey)); \
    UIViewController *pageVC = \
    SFRouterCallObjcAction([PageClassName alloc], UIViewController *, init_, RouterKey, ##__VA_ARGS__); \
    openPage(sender, pageVC); \
    return pageVC;\
} \
SFRouter_ObjC_Function(0, UIViewController *, init_, RouterKey, ##__VA_ARGS__)

// 使用页面
#define SFRouterUsePage(RouterKey, ...)\
SFRouterWriteInfo(1, 0, @"UnknownTip", RouterKey, UIViewController *, ##__VA_ARGS__)\
SFRouter_Extern_C_Function(Class, get_, RouterKey ## _class); \
SFRouter_Extern_C_Function(UIViewController *, open_, RouterKey ## _page, (id)sender , ##__VA_ARGS__);

// action 注册
#define SFRouterRegisterAction(RouterTip, RouterKey, ReturnType, ...)        \
SFRouterWriteInfo(0, 1, RouterTip, RouterKey, ReturnType, ##__VA_ARGS__)\
SFRouter_C_Function(ReturnType, action_, RouterKey, __VA_ARGS__) {                  \
    Class ClassName = classForRouterKey(@metamacro_stringify(RouterKey)); \
    SFRouterCheckVoid(ReturnType)()(return)                                         \
    SFRouterCallObjcAction(ClassName, ReturnType, action_, RouterKey, ##__VA_ARGS__);      \
}                                                                                   \
SFRouter_ObjC_Function(1, ReturnType, action_, RouterKey, ##__VA_ARGS__)

// action方法使用
#define SFRouterUseAction(RouterKey, ReturnType, ...)\
SFRouterWriteInfo(1, 1, @"UnknownTip", RouterKey, ReturnType, ##__VA_ARGS__)\
SFRouter_Extern_C_Function(ReturnType, action_, RouterKey, __VA_ARGS__);

// oc方法调用
#define SFRouterCallObjcAction(Obj, ReturnType, FuncPrefix, RouterKey, ...)   \
[Obj SFRouterCreateNameStr(SFRouterParamOriginValue, FuncPrefix, RouterKey, SFRouterGenerate_ObjC_ParamsList(SFRouter_ObjC_ParamValue, ##__VA_ARGS__))]


#endif /* SFRouterMacros_h */
