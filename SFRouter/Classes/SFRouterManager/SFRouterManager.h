//
//  SFRouterManager.h
//  SFRouter
//
//  Created by longfei on 2020/9/7.
//

#import <UIKit/UIKit.h>
#import "SFRouterRunner.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFRouterManager : NSObject

@property (nonatomic, copy) NSURL * (^handleOpenUrlAspect)(NSString *url); ///< open 前预处理操作，返回可被解析的URL

@property (nonatomic, copy) void (^handleOpenUrlFailed)(NSError *error); ///< handle 解析失败

@property (nonatomic, copy) UIViewController *(^suitablePosterForSender)(id sender); ///< 获取合适page的弹出者

@property (nonatomic, copy) void (^openH5Page)(NSURL *url); ///< 打开H5页面

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedManager;

- (void)prepareLoadRouterData;

- (Class)classForRouterKey:(NSString *)routerKey;

- (BOOL)canRouterForUrl:(NSString *)url;

- (void)routerForUrl:(NSString *)url data:(nullable NSDictionary *)data sender:(nullable id)sender;

- (void)openPage:(UIViewController *)pageVC sender:(id)sender;

@end

NS_ASSUME_NONNULL_END
