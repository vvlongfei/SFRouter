//
//  SFRouter.m
//  SFRouter
//
//  Created by longfei on 2020/8/6.
//

#import "SFRouter.h"
#import "SFRouterManager.h"

void openPage(UIViewController *sender, UIViewController *pageVC) {
    [[SFRouterManager sharedManager] openPage:pageVC sender:sender];
}


@implementation SFRouter

+ (void)openPage:(UIViewController *)pageVC sender:(UIViewController *)sender {
    [[SFRouterManager sharedManager] openPage:pageVC sender:sender];
}

+ (BOOL)canRouterForUrl:(NSString *)url {
    return [[SFRouterManager sharedManager] canRouterForUrl:url];
}

+ (void)routerForUrl:(NSString *)url {
    [self routerForUrl:url data:nil sender:nil];
}

+ (void)routerForUrl:(NSString *)url sender:(id)sender {
    [self routerForUrl:url data:nil sender:sender];
}

+ (void)routerForUrl:(NSString *)url data:(NSDictionary *)data {
    [self routerForUrl:url data:data sender:nil];
}

+ (void)routerForUrl:(NSString *)url data:(NSDictionary *)data sender:(id)sender {
    [[SFRouterManager sharedManager] routerForUrl:url data:data sender:sender];
}

@end
