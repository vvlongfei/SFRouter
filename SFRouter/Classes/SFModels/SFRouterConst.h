//
//  SFRouterConst.h
//  SFRouter
//
//  Created by longfei on 2020/9/10.
//

#ifndef SFRouterConst_h
#define SFRouterConst_h

extern NSString * const SFRouterDomain;

typedef struct _SFRouterParam {
    char *name;          ///< 参数名
    char *typeName;      ///< 参数类型名
    char *typeEncoding;  ///< 参数类型encode
    BOOL isRequire;      ///<  参数是否为必须
} SFRouterParam;

typedef struct _SFRouterInfo {
    char *key;              ///< 路由key
    __unsafe_unretained NSString *keyDescription;   ///< 路由描述
    BOOL isAction;          ///< 表明是页面路由还是方法路由
    
    char *className;        ///< 类名
    char *filePath;         ///< 获取文件路径
    
    char *returnTypeName;     ///< 返回值类型
    char *returnTypeEncoding; ///< 返回值类型encode
    
    SFRouterParam *params;  ///< 参数列表
    uint32_t paramsCount;    ///< 参数个数
    
    char *selName;  ///< 方法名
} SFRouterInfo;

#endif /* SFRouterConst_h */
