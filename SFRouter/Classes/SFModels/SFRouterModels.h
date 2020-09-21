//
//  SFRouterModels.h
//  SFRouter
//
//  Created by longfei on 2020/8/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* SFRouterKey;

@interface SFRouterParamItem : NSObject
@property (nonatomic, copy) NSString *name;         ///< 属性名称
@property (nonatomic, copy) NSString *typeName;     ///< 属性类型名称
@property (nonatomic, copy) NSString *typeEncoding; ///< 属性编码
@property (nonatomic, assign) BOOL isRequire;       ///< 是否为必选参数
- (BOOL)checkEqualForParamItem:(SFRouterParamItem *)paramItem;
@end

@interface SFRouterInfoItem : NSObject
@property (nonatomic, copy) SFRouterKey key;            ///< 路由key值
@property (nonatomic, copy) NSString *keyDescription;   ///< 路由标注描述
@property (nonatomic, assign) BOOL isAction;            ///< 路由是否为action、page
@property (nonatomic, copy) NSString *className;        ///< 对应类名
@property (nonatomic, copy) NSString *filePath;         ///< 路由文件路径
@property (nonatomic, assign) NSInteger lineNum;        ///< 路由对应行
@property (nonatomic, copy) NSString *returnTypeName;   ///< 返回值类型名
@property (nonatomic, copy) NSString *returnTypeEncoding;           ///< 返回类型编码
@property (nonatomic, copy) NSArray<SFRouterParamItem *> *params;   ///< 路由参数
@property (nonatomic, assign) NSUInteger paramsCount;   ///< 参数个数
@property (nonatomic, copy) NSString *selName;          ///< 路由方法sel

- (NSError *)checkEqualForInfoItem:(SFRouterInfoItem *)infoItem;

@end

NS_ASSUME_NONNULL_END
