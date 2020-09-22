//
//  SFRouterPrivate.h
//  SFRouter
//
//  Created by longfei on 2020/8/26.
//

#ifndef SFRouterPrivate_h
#define SFRouterPrivate_h

#import <SFRouter/SFRouterConst.h>
#import <SFRouter/SFMetamacros.h>

#pragma mark - 路由数据写入
#define SFRouterParamStruct(INDEX, VALUE)                               \
metamacro_if_eq(0,INDEX)()(,)                                           \
{                                                                       \
    .name = metamacro_stringify(SFRouterParamGetName(VALUE)) ,          \
    .typeName = metamacro_stringify(SFRouterParamGetType(VALUE)) ,      \
    .typeEncoding = @encode(SFRouterParamGetType(VALUE)),               \
    .isRequire = SFRouterParamRequire(VALUE)                           \
}

#define SFRouterFuncPrefix(IsAction, RouterKey)\
metamacro_if_eq(IsAction, 1)(action_ ## RouterKey)(init_ ## RouterKey)

#define SFRouterSectionData(IsCheck) \
metamacro_if_eq(IsCheck, 1)("__DATA, __LJRouterCheck")("__DATA, __LJRouterData")

#define SFRouterCreateLineStrWithParams(Prefix, Sufix, ...)\
SFRouterCreateNameStr(SFRouterParamLineValue, Prefix, SFRouterGetParamNameList(__VA_ARGS__), Sufix)

#define SFRouterCreateFuncSEL(Prefix, ...)\
SFRouterCreateNameStr(SFRouterParamOriginValue, Prefix, SFRouterGenerate_ObjC_ParamsList(SFRouter_ObjC_ParamSEL, ##__VA_ARGS__))

/*路由数据写入*/
#define SFRouterWriteInfo(IsCheck, IsAction, RouterTip, RouterKey, ReturnType, ...)  \
+ (void) SFRouterCreateLineStrWithParams(SFRouter_regInfo ## RouterKey, ,##__VA_ARGS__) {        \
    __used static SFRouterParam                                                          \
    SFRouterCreateLineStrWithParams(SFRouter_ ## RouterKey, Params[], ##__VA_ARGS__) =          \
    {                                                                                           \
        SFRouterForeachForMacro(SFRouterParamStruct, ##__VA_ARGS__)                               \
    };                                                                                          \
    __used static SFRouterInfo                                                       \
        SFRouterCreateLineStrWithParams(SFRouter_ ## RouterKey, SFRouterInfo, ##__VA_ARGS__)    \
        __attribute__ ((used, section (SFRouterSectionData(IsCheck))))                          \
    = {                                                                                         \
        .method = __FUNCTION__,                                            \
        .filePath = __FILE__,                                                                  \
        .lineNum = __LINE__,                                                                    \
        .key = #RouterKey,                                                                      \
        .keyDescription = RouterTip,                                               \
        .returnTypeName = metamacro_stringify(ReturnType),                                      \
        .returnTypeEncoding = @encode(ReturnType),                                              \
        .params = SFRouterCreateLineStrWithParams(SFRouter_ ## RouterKey, Params, ##__VA_ARGS__), \
        .paramsCount =metamacro_dec(metamacro_argcount(1,##__VA_ARGS__)),                       \
        .isAction = IsAction,                                                                   \
        .selName = metamacro_stringify(SFRouterCreateFuncSEL(SFRouterFuncPrefix(IsAction, RouterKey),               \
                                           ##__VA_ARGS__)),                                        \
    };                                                                                          \
}

#pragma mark - oc函数相关
/// OC函数语句
#define SFRouter_ObjC_Function(IsClassMethod, ReturnType, FuncPrefix, RouterKey, ...) \
metamacro_if_eq(IsClassMethod, 1) (+) (-) \
(ReturnType)SFRouterCreateNameStr(SFRouterParamOriginValue, FuncPrefix, RouterKey, SFRouterGenerate_ObjC_ParamsList(SFRouter_ObjC_Param, ##__VA_ARGS__))

/// OC函数参数列表，
/// 将产生两个参数，一个 _with_ , 另一个为所有参数的组合体，如：a:(int)a b:(int)b 或 a:a b:b 或 a: b:
#define SFRouterGenerate_ObjC_ParamsList(MACRO, ...)       \
metamacro_if_eq(1, metamacro_argcount(1, ##__VA_ARGS__))   \
()                                                     \
(metamacro_foreach(MACRO, ,##__VA_ARGS__))

// OC函数参数项:a:(int)a
#define SFRouter_ObjC_Param(INDEX, VALUE)  \
metamacro_if_eq(0, INDEX) (_with_,)()\
SFRouterParamGetName(VALUE):VALUE

// OC函数参数项a:a
#define SFRouter_ObjC_ParamValue(INDEX, VALUE)  \
metamacro_if_eq(0, INDEX) (_with_,)()\
SFRouterParamGetName(VALUE):SFRouterParamGetName(VALUE)

// OC函数参项SEL
#define SFRouter_ObjC_ParamSEL(INDEX, VALUE)  \
metamacro_if_eq(0, INDEX) (_with_,)()\
SFRouterParamGetName(VALUE):

#pragma mark - C函数相关
/// C函数语句
#define SFRouter_C_Function(ReturnType, FuncPrefix, RouterKey, ...) \
ReturnType SFRouterCreateNameStr(SFRouterParamOriginValue, FuncPrefix, RouterKey)(SFRouterGenerate_C_ParamsList(__VA_ARGS__))


#define SFRouter_Extern_C_Function(ReturnType, FuncPrefix, RouterKey, ...)  \
extern ReturnType SFRouterCreateNameStr(SFRouterParamOriginValue, FuncPrefix, RouterKey)(SFRouterGenerate_C_ParamsList(__VA_ARGS__));

// C函数参数列表
#define SFRouterGenerate_C_ParamsList(...)              \
metamacro_if_eq(1, metamacro_argcount(1, ##__VA_ARGS__))  \
(void)                                                  \
(metamacro_foreach(SFRouter_C_Param, , ##__VA_ARGS__))

// C函数参数 NSString *name
#define SFRouter_C_Param(INDEX, VALUE)  \
metamacro_if_eq(0, INDEX) ()(,)         \
SFRouterParamGetType(VALUE)             \
SFRouterParamGetName(VALUE)

#pragma mark - 基础宏
// 将参数串联为字符串，MACRO是对参数连接方式
#define SFRouterCreateNameStr(MACRO, ...)                          \
metamacro_if_eq(1, metamacro_argcount(1, ##__VA_ARGS__))    \
(_default)                                                  \
(metamacro_concat_all(metamacro_head(__VA_ARGS__),          \
metamacro_foreach(MACRO, ,metamacro_tail(__VA_ARGS__))))
        
#define SFRouterParamLineValue(INDEX,VALUE)     \
,metamacro_concat(_,VALUE)

#define SFRouterParamOriginValue(INDEX,VALUE)             \
,VALUE

// 循环宏处理
#define SFRouterForeachForMacro(MACRO, ...)\
metamacro_if_eq(1, metamacro_argcount(1, ##__VA_ARGS__))    \
()                                                  \
(metamacro_foreach(MACRO, ,##__VA_ARGS__))
 
// 获取参数名列表
#define SFRouterGetParamNameList(...)                       \
metamacro_if_eq(1, metamacro_argcount(1, ##__VA_ARGS__))    \
(void)                                                          \
(metamacro_foreach(SFRouterParamNameItem, , ##__VA_ARGS__))

// 获取函数参数名及逗号分隔符 name
#define SFRouterParamNameItem(INDEX, VALUE)     \
metamacro_if_eq(0, INDEX) ()(,)                 \
SFRouterParamGetName(VALUE)

// 检查是否为void
#define SFRouterCheckVoid_void ,
#define SFRouterCheckVoid(param) \
metamacro_if_eq(metamacro_argcount(SFRouterCheckVoid_ ## param), 2)

// 获取参数名， 举例(NSString *)name 去掉了（NSString *)，只剩name
#define SFRouterParamGetName(param) SFRouterParamRemoveType_ param
#define SFRouterParamRemoveType_(...)  // 空实现，会去掉括号内容

// 获取参数类型
#define SFRouterParamGetType(param) \
metamacro_head(SFRouterParamGetType_ param)
// 除去参数中的括号，并去掉可能存在的nullable。最重要的是添加了逗号，使参数变为两个:NSString *, name
#define SFRouterParamGetType_(param) \
SFRouterParamTypeNullableCheck(param) \
(SFRouterParamTypeRemoveNullable_ ## param,)  \
(param,)

// 用于去掉完整参数类型前的nullable
#define SFRouterParamTypeRemoveNullable_nullable
// 用于分割完整参数类型中nullable与type
#define SFRouterParamTypeNullableCheck_nullable nullable,
// 判断参数类型是否可为空
#define SFRouterParamTypeNullableCheck(param)                                   \
metamacro_if_eq(metamacro_argcount(SFRouterParamTypeNullableCheck_ ## param), 2)

// 检查参数是否为毕传参数
#define SFRouterParamRequire(param)           \
metamacro_head(SFRouterParamRequire_ param)

#define SFRouterParamRequire_(param)           \
SFRouterParamTypeNullableCheck(param) (NO)(YES),


// 字符串化参数列表
#define metamacro_stringify_all(SUB, ...) \
    metamacro_concat(metamacro_stringify_all,metamacro_argcount(__VA_ARGS__))(SUB,__VA_ARGS__)

#define metamacro_stringify_all1(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__))

#define metamacro_stringify_all2(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all1(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all3(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all2(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all4(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all3(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all5(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all4(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all6(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all5(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all7(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all6(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all8(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all7(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all9(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all8(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all10(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all9(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all11(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all10(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all12(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all11(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all13(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all12(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all14(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all13(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all15(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all14(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all16(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all15(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all17(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all16(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all18(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all17(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all19(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all18(SUB,metamacro_tail(__VA_ARGS__))
#define metamacro_stringify_all20(SUB, ...) \
    metamacro_stringify(metamacro_head(__VA_ARGS__)) SUB  metamacro_stringify_all19(SUB,metamacro_tail(__VA_ARGS__))

// 字符串连接，原生会产生空格
#define metamacro_concat_all(...)                       \
        metamacro_concat(metamacro_concat_all,metamacro_argcount(__VA_ARGS__))(__VA_ARGS__)

#define metamacro_concat_all1(...) __VA_ARGS__
#define metamacro_concat_all2(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all1(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all3(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all2(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all4(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all3(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all5(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all4(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all6(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all5(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all7(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all6(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all8(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all7(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all9(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all8(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all10(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all9(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all11(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all10(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all12(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all11(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all13(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all12(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all14(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all13(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all15(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all14(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all16(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all15(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all17(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all16(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all18(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all17(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all19(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all18(metamacro_tail(__VA_ARGS__)))
#define metamacro_concat_all20(...) metamacro_concat(metamacro_head(__VA_ARGS__),metamacro_concat_all19(metamacro_tail(__VA_ARGS__)))

#endif /* SFRouterPrivate_h */
