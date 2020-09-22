//
//  SFRouterRunner.h
//  SFRouter
//
//  Created by longfei on 2020/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SFRouterRunner,SFRouterInfoItem;

@protocol SFRouterRunnerDelegate <NSObject>

@required
- (void)routerRunner:(SFRouterRunner *)runner openPage:(UIViewController *)pageVC sender:(id)sender;

@optional
- (void)routerRunner:(SFRouterRunner *)runner willOpenPage:(UIViewController *)pageVC sender:(id)sender;
- (void)routerRunner:(SFRouterRunner *)runner didOpenedPage:(UIViewController *)pageVC sender:(id)sender;

- (void)routerRunner:(SFRouterRunner *)runner willCallAction:(NSInvocation *)invocation;
- (void)routerRunner:(SFRouterRunner *)runner didCalledAction:(NSInvocation *)invocation;

@end

@interface SFRouterRunner : NSObject

@property (nonatomic, strong) SFRouterInfoItem *infoItem; ///< 路由信息

- (void)runWithDelegate:(id<SFRouterRunnerDelegate>)delegate sender:(id)sender;

+ (instancetype)createRunnerWithUrl:(NSURL *)url data:(nullable NSDictionary *)data routerMap:(NSDictionary *)routerMap error:(NSError * __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
