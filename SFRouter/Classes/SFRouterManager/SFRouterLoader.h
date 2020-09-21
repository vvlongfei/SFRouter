//
//  SFRouterLoader.h
//  Pods-SFRouter_Example
//
//  Created by longfei on 2020/9/11.
//

#import <Foundation/Foundation.h>
#import "SFRouterModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFRouterLoader : NSObject

@property (readonly) NSDictionary<SFRouterKey, SFRouterInfoItem *> *routerMap; ///< 路由数据

- (void)loadRouterData;

@end

NS_ASSUME_NONNULL_END
