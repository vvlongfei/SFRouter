//
//  SFRouterValueConvert.m
//  SFRouter
//
//  Created by longfei on 2020/9/12.
//

#import "SFRouterValueConvert.h"
#import "SFRouterModels.h"
#import "YYModel.h"

extern NSString * const SFRouterDomain;

@implementation SFRouterValueConvert

+ (NSError *)setParam:(NSString *)value index:(NSUInteger)index paramInfo:(SFRouterParamItem *)paramItem forInvocation:(NSInvocation *)invocation {
    NSError *error = nil;
    const char *type = paramItem.typeEncoding.UTF8String;
    if (value == nil) {
        if (paramItem.isRequire) {
            error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
                NSLocalizedFailureReasonErrorKey:@"缺少必要参数"
            }];
        }
    } else if (![value isKindOfClass:NSString.class]) {
        // wlf - TODO:  带扩展，该value自data
        if (strcmp(type, @encode(__typeof__(value))) == 0) {
            [invocation setArgument:&value atIndex:(index + 2)];
        } else {
            error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
                NSLocalizedFailureReasonErrorKey:@"参数类型与value值类型不一致"
            }];
        }
    } else if (strcmp(type, @encode(id)) == 0) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:(0)];
        if ([paramItem.typeName hasPrefix:NSStringFromClass(NSString.class)]) {
            NSString *realValue = value;
            if (data) {
                realValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            [invocation setArgument:&realValue atIndex:(index + 2)];
        }
        else if ([paramItem.typeName hasPrefix:NSStringFromClass(NSDictionary.class)] ||
                 [paramItem.typeName hasPrefix:NSStringFromClass(NSArray.class)]) {
            NSError * __autoreleasing convertError;
            data = data ?: [value dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                         options:(NSJSONReadingMutableContainers)
                                                           error:&convertError];
            if (!convertError) {
                [invocation setArgument:&jsonObj atIndex:(index + 2)];
            } else if (paramItem.isRequire) {
                error = convertError;
            }
        }
        else if (paramItem.isRequire){
            error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
                NSLocalizedFailureReasonErrorKey:@"参数类型不支持URL调用"
            }];
        }
    } else if (strcmp(type, @encode(double)) == 0) {
        double realValue = value.doubleValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(float)) == 0) {
        float realValue = value.floatValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(int)) == 0) {
        int realValue = value.intValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(long)) == 0) {
        long realValue = value.longLongValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long realValue = value.longLongValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(short)) == 0) {
        short realValue = value.intValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(char)) == 0) {
        char realValue = value.intValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(bool)) == 0) {
        BOOL realValue = value.boolValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        NSNumberFormatter *ff = [[NSNumberFormatter alloc]  init];
        NSNumber *num = [ff numberFromString:value];
        u_char realValue = num.unsignedCharValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        NSNumberFormatter *ff = [[NSNumberFormatter alloc]  init];
        NSNumber *num = [ff numberFromString:value];
        uint realValue = num.unsignedIntValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        NSNumberFormatter *ff = [[NSNumberFormatter alloc]  init];
        NSNumber *num = [ff numberFromString:value];
        u_long realValue = num.unsignedLongValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        NSNumberFormatter *ff = [[NSNumberFormatter alloc]  init];
        NSNumber *num = [ff numberFromString:value];
        unsigned long long realValue = num.unsignedLongLongValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        NSNumberFormatter *ff = [[NSNumberFormatter alloc]  init];
        NSNumber *num = [ff numberFromString:value];
        ushort realValue = num.unsignedShortValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    }
    [invocation retainArguments];
    return error;
}

@end
