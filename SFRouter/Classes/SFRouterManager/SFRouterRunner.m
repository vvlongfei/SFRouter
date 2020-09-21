//
//  SFRouterRunner.m
//  SFRouter
//
//  Created by longfei on 2020/9/15.
//

#import "SFRouterRunner.h"
#import "SFRouterModels.h"
#import "SFRouterValueConvert.h"

extern NSString * const SFRouterDomain;

@interface SFRouterRunner ()
@property (nonatomic, strong) NSInvocation *invocation; ///< 方法执行体
@end

@implementation SFRouterRunner

- (void)runWithDelegate:(id<SFRouterRunnerDelegate>)delegate sender:(nonnull id)sender {
    if (self.infoItem.isAction) {
        [self.invocation invokeWithTarget:NSClassFromString(self.infoItem.className)];
        if ([delegate respondsToSelector:@selector(actionFinished)]) {
            [delegate actionFinished];
        }
    } else if ([delegate respondsToSelector:@selector(openPage:sender:)]) {
        UIViewController *pageVC = [NSClassFromString(self.infoItem.className) alloc];
        [self.invocation invokeWithTarget:pageVC]; // 执行其init函数
        [delegate openPage:pageVC sender:sender];
    }
}

+ (instancetype)createRunnerWithUrl:(NSURL *)url data:(nullable NSDictionary *)data routerMap:(nonnull NSDictionary *)routerMap error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    SFRouterKey routerKey = [self routerKeyForUrl:url];
    SFRouterInfoItem *infoItem = routerMap[routerKey];
    if (!infoItem) {
        if (error) {
            *error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
                NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"对应路由不存在 url:%@, data:%@", url, data]
            }];
        }
        return nil;
    }
    NSMutableDictionary *urlParams = [self paramsForUrl:url];
    [urlParams addEntriesFromDictionary:data];
    
    NSInvocation *invocation = [self getInvocationWithRouterInfo:infoItem data:urlParams error:error];
    if (!invocation) {
        return nil;
    }
    SFRouterRunner *runner = [self new];
    runner.invocation = invocation;
    runner.infoItem = infoItem;
    return runner;
}

+ (SFRouterKey)routerKeyForUrl:(NSURL *)url {
    NSString *srcKey = [url.host stringByAppendingString:url.path];
    SFRouterKey routerKey = [srcKey stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return routerKey;
}

+ (NSMutableDictionary *)paramsForUrl:(NSURL *)url {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableDictionary *urlParams = [NSMutableDictionary dictionary];
    
    for (NSURLQueryItem *temp in components.queryItems) {
        [urlParams setValue:temp.value forKey:temp.name];
    }
    
    return urlParams;
}

+ (NSInvocation *)getInvocationWithRouterInfo:(SFRouterInfoItem *)infoItem data:(NSDictionary *)data error:(NSError **)error {
    NSMethodSignature *sig;
    
    if (infoItem.isAction) {
        sig = [NSClassFromString(infoItem.className) methodSignatureForSelector:NSSelectorFromString(infoItem.selName)];
    } else {
        Class pageClass = NSClassFromString(infoItem.className);
        if (![pageClass isSubclassOfClass:UIViewController.class]) {
            if (error) {
                *error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
                    NSLocalizedFailureReasonErrorKey : @"page.class 非uiviewcontroller子类"
                }];
            }
            return nil;
        }
        sig = [pageClass instanceMethodSignatureForSelector:NSSelectorFromString(infoItem.selName)];
    }
    
    if (!sig) {
        // 获取签名失败
        if (error) {
            *error = [NSError errorWithDomain:SFRouterDomain code:-1 userInfo:@{
                NSLocalizedFailureReasonErrorKey : @"对应方法实现未找到"
            }];
        }
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.selector = NSSelectorFromString(infoItem.selName);
    
    __block NSError *paramError;
    [infoItem.params enumerateObjectsUsingBlock:^(SFRouterParamItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = data[obj.name];
        if ((paramError = [SFRouterValueConvert setParam:value index:idx paramInfo:obj forInvocation:invocation])) {
            *stop = YES;
        }
    }];
    if (paramError) {
        // 参数设置有问题
        if (error) {
            *error = paramError;
        }
        return nil;
    }
    
    return invocation;
}

@end
