//
//  SFRouterManager.m
//  SFRouter
//
//  Created by longfei on 2020/9/7.
//

#import "SFRouterManager.h"
#import "SFRouterLoader.h"

extern NSString * const SFRouterDomain;

@interface SFRouterManager ()<SFRouterRunnerDelegate>
@property SFRouterLoader *routerLoader;
@end

@implementation SFRouterManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SFRouterManager *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[SFRouterManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _routerLoader = [SFRouterLoader new];
    }
    return self;
}

- (void)prepareLoadRouterData {
    [_routerLoader loadRouterData];
}

- (BOOL)canRouterForUrl:(NSString *)url {
    NSURL *optUrl = nil;
    if (self.handleOpenUrlAspect) {
        optUrl = self.handleOpenUrlAspect(url);
    }
    if (!optUrl) {
        optUrl = [NSURL URLWithString:url];
    }
    if ([optUrl.scheme hasPrefix:@"http"]) {
        return self.openH5Page ? YES : NO;
    }
    SFRouterRunner *runner = [SFRouterRunner createRunnerWithUrl:optUrl data:nil routerMap:self.routerLoader.routerMap error:nil];
    
    return runner ? YES : NO;
}

- (void)routerForUrl:(NSString *)url data:(NSDictionary *)data sender:(id)sender {
    NSURL *optUrl = nil;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // nsurl支持中文
    if (self.handleOpenUrlAspect) {
        optUrl = self.handleOpenUrlAspect(url);
    }
    if (!optUrl) {
        optUrl = [NSURL URLWithString:url];
    }
    if ([optUrl.scheme hasPrefix:@"http"]) {
        if (self.openH5Page) {
            self.openH5Page(optUrl);
        }
        return;
    }
    SFRouterRunner *runner = [SFRouterRunner createRunnerWithUrl:optUrl data:data routerMap:self.routerLoader.routerMap error:nil];
    if (runner) {
        [runner runWithDelegate:self sender:sender];
    }
}

- (void)openPage:(UIViewController *)pageVC sender:(id)sender {
    UIViewController *senderVC = sender;
    if (![sender isKindOfClass:UIViewController.class]) {
        senderVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    }
    
    if (self.suitablePosterForSender) {
        senderVC = self.suitablePosterForSender(senderVC);
    } else {
        senderVC = [self defaultSuitablePosterForSender:senderVC];
    }
    
    if (senderVC.navigationController) {
        [senderVC.navigationController pushViewController:pageVC animated:YES];
    } else if ([senderVC isKindOfClass:UINavigationController.class]) {
        
        [(UINavigationController *)senderVC pushViewController:pageVC animated:YES];
    } else {
        [senderVC presentViewController:pageVC animated:YES completion:nil];
    }
}

- (void)actionFinished {
    // wlf - TODO:  待完善

}

- (UIViewController *)defaultSuitablePosterForSender:(UIViewController *)sender {
    UIViewController *container = sender?:[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (container.presentedViewController) {
        container = container.presentedViewController;
    }
    if ([container isKindOfClass:UITabBarController.class]) {
        UITabBarController *tabbarController = (UITabBarController *)container;
        if ([[tabbarController selectedViewController] isKindOfClass:UINavigationController.class]) {
            container = [tabbarController selectedViewController];
        }
    }
    if ([container isKindOfClass:UINavigationController.class]) {
        container = ((UINavigationController *)container).topViewController;
    }
    return container;
}

@end
