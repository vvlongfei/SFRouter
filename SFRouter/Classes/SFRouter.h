//
//  SFRouter.h
//  SFRouter
//
//  Created by longfei on 2020/8/6.
//

#import <Foundation/Foundation.h>
//#import "SFRouterDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFRouter : NSObject

+ (void)openPage:(UIViewController *)pageVC sender:(id)sender;

+ (BOOL)canRouterForUrl:(NSString *)url;

+ (void)routerForUrl:(NSString *)url;

+ (void)routerForUrl:(NSString *)url sender:(nullable id)sender;

+ (void)routerForUrl:(NSString *)url data:(nullable NSDictionary *)data;

+ (void)routerForUrl:(NSString *)url data:(nullable NSDictionary *)data sender:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
