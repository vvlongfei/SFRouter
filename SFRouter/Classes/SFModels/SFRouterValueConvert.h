//
//  SFRouterValueConvert.h
//  SFRouter
//
//  Created by longfei on 2020/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SFRouterParamItem;

@interface SFRouterValueConvert : NSObject

/// 根据typeEncoding，转换为NSNumber、
+ (NSError *)setParam:(NSString *)value index:(NSUInteger)index
       paramInfo:(SFRouterParamItem *)paramItem forInvocation:(NSInvocation *)invocation;

@end

NS_ASSUME_NONNULL_END
