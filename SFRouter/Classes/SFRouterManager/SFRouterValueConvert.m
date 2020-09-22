//
//  SFRouterValueConvert.m
//  SFRouter
//
//  Created by longfei on 2020/9/12.
//

#import "SFRouterValueConvert.h"
#import "SFRouterModels.h"

extern NSString * const SFRouterDomain;

@implementation SFRouterValueConvert

+ (NSError *)setParam:(id)value index:(NSUInteger)index paramInfo:(SFRouterParamItem *)paramItem forInvocation:(NSInvocation *)invocation {
    NSError *error = nil;
    const char *type = paramItem.typeEncoding.UTF8String;
    if (value == nil) {
        if (paramItem.isRequire) {
            error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
                NSLocalizedFailureReasonErrorKey:@"缺少必要参数"
            }];
        }
    } else if (![value isKindOfClass:NSString.class]) {
        // 如果value不是string值，则表明该值不是不是从URL中解析出来的，而是通过NSDictionry传入的
        if ([value isKindOfClass:NSNumber.class]) {
            [self setNumber:value typeEncoding:type index:index forInvocation:invocation];
        } else if (strcmp(type, @encode(__typeof__(value))) == 0) {
            [invocation setArgument:&value atIndex:(index + 2)];
            [invocation retainArguments];
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
        [invocation retainArguments];
    } else {
        NSNumberFormatter *ff = [[NSNumberFormatter alloc]  init];
        NSNumber *num = [ff numberFromString:value];
        [self setNumber:num typeEncoding:type index:index forInvocation:invocation];
    }
    return error;
}

+ (void)setNumber:(NSNumber *)value typeEncoding:(const char *)type index:(NSUInteger)index  forInvocation:(NSInvocation *)invocation {
    if (strcmp(type, @encode(double)) == 0) {
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
        u_char realValue = value.unsignedCharValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        uint realValue = value.unsignedIntValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        u_long realValue = value.unsignedLongValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long realValue = value.unsignedLongLongValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        ushort realValue = value.unsignedShortValue;
        [invocation setArgument:&realValue atIndex:(index + 2)];
    }
    [invocation retainArguments];
}

@end
