//
//  SFRouterModels.m
//  SFRouter
//
//  Created by longfei on 2020/8/26.
//

#import "SFRouterModels.h"

NSString * const SFRouterDomain = @"com.shawnfly.router";

@implementation SFRouterParamItem
- (BOOL)checkEqualForParamItem:(SFRouterParamItem *)paramItem {
    if (![paramItem.name isEqualToString:self.name]) {
        return NO;
    } else if (![paramItem.typeName isEqualToString:self.typeName]) {
        return NO;
    } else if (![paramItem.typeEncoding isEqualToString:self.typeEncoding]) {
        return NO;
    }
    return YES;
}
@end

@implementation SFRouterInfoItem
- (NSError *)checkEqualForInfoItem:(SFRouterInfoItem *)infoItem {
    NSError *error = nil;
    if (infoItem.isAction != self.isAction) {
        error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
            NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"路由类型对应不上，filePath:%@", self.filePath]
        }];
    } else if (![infoItem.returnTypeName isEqualToString:self.returnTypeName]) {
        error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
            NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"路由返回值类型对应不上，filePath:%@", self.filePath]
        }];
    } else if (infoItem.paramsCount != self.paramsCount) {
        error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
            NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"路由参数个数对应不上，filePath:%@", self.filePath]
        }];
    } else if (![infoItem.selName isEqualToString:self.selName]) {
        error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
            NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"路由方法名对应不上，filePath:%@", self.filePath]
        }];
    } else {
        for (NSUInteger index = 0; index < self.paramsCount; ++index) {
            BOOL result = [infoItem.params[index] checkEqualForParamItem:self.params[index]];
            if (!result) {
                // 添加路径信息
                error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
                    NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"路由参数校验失败，filePath:%@", self.filePath]
                }];
                break;
            }
        }
    }
    return error;
}
@end
