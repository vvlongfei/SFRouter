//
//  SFRouterLoader.m
//  Pods-SFRouter_Example
//
//  Created by longfei on 2020/9/11.
//

#import "SFRouterLoader.h"
#import "SFRouterConst.h"

#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <mach-o/getsect.h>
#import <mach-o/dyld_images.h>
#import <objc/runtime.h>

#ifndef __LP64__
    #define section section
    #define mach_header mach_header
#else
    #define section section_64
    #define mach_header mach_header_64
#endif

typedef BOOL(^SFRouterCheckKey)(SFRouterKey routerKey, NSString *filePath);
typedef void(^SFRouterInfoReader)(SFRouterKey routerKey, SFRouterInfoItem *infoItem);

typedef NS_ENUM(NSUInteger, SFRouterDataType) {
    SFRouterDataTypeRouterRegister, ///<  注册路由读取
    SFRouterDataTypeRouterCheck,    ///<  校验路由读取
};

@interface SFRouterLoader ()
@property NSMutableDictionary<SFRouterKey, SFRouterInfoItem *> *routerDataMap; ///< 路由数据
@property BOOL hasLoaded;
@end

@implementation SFRouterLoader

- (instancetype)init {
    self = [super init];
    if (self) {
        _routerDataMap = [NSMutableDictionary dictionary];
        _hasLoaded = NO;
    }
    return self;
}

/// 加载路由数据
- (void)loadRouterData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _loadRouterData];
        [self _verifyRouterNativeCall];
    });
    _hasLoaded = YES;
}

- (NSDictionary<SFRouterKey,SFRouterInfoItem *> *)routerMap {
    if (!_hasLoaded) {
        [self loadRouterData];
    }
    return _routerDataMap;
}

/// 同名函数调用
- (void)_loadRouterData {
    /// 加载逻辑
    [self loadRouterDataForType:SFRouterDataTypeRouterRegister
                       checkKey:^BOOL(SFRouterKey routerKey, NSString *filePath) {
        NSAssert(routerKey.length > 0, @"路由key长度必须大于0，filePath:%@", filePath);
        NSAssert(self.routerDataMap[routerKey] == nil, @"路由key重复，routerKey:%@, filePath1:%@, filePath2:%@", routerKey, self.routerDataMap[routerKey].filePath, filePath);
        if (routerKey.length == 0 || self.routerDataMap[routerKey]) {
            return NO;; // 不记录key长度为0的路由、不记录重复的路由
        }
        return YES;
    } readerInfoItem:^(SFRouterKey routerKey, SFRouterInfoItem *infoItem) {
        [self.routerDataMap setValue:infoItem forKey:infoItem.key];
    }];
    
}

/// 检测native调用是否正常
- (void)_verifyRouterNativeCall {
    [self loadRouterDataForType:SFRouterDataTypeRouterCheck
                       checkKey:^BOOL(SFRouterKey routerKey, NSString *filePath) {
        NSAssert(routerKey.length > 0, @"路由引用key长度必须大于0，filePath:%@", filePath);
        NSAssert(self.routerDataMap[routerKey], @"引用路由不存在 routerKey:%@, filePath:%@", routerKey, filePath);
        if (routerKey.length == 0 || !self.routerDataMap[routerKey]) {
            return NO;; // 不记录key长度为0的路由、不记录重复的路由
        }
        return YES;
    } readerInfoItem:^(SFRouterKey routerKey, SFRouterInfoItem *infoItem) {
        SFRouterInfoItem *originInfoItem = self.routerDataMap[routerKey];
        NSError *error = [infoItem checkEqualForInfoItem:originInfoItem];
        NSAssert(!error, error.localizedFailureReason);
    }];
}

- (void)loadRouterDataForType:(SFRouterDataType)type checkKey:(SFRouterCheckKey)checkKey readerInfoItem:(SFRouterInfoReader)readerInfoItem {
    NSParameterAssert(checkKey && readerInfoItem);
    NSString *sectionName = type == SFRouterDataTypeRouterRegister ? @"__LJRouterData" : @"__LJRouterCheck";
    uint32_t headerCount = _dyld_image_count();
    for (uint32_t headerIndex = 0; headerIndex < headerCount; ++headerIndex) {
        const struct mach_header *header = (void *)_dyld_get_image_header(headerIndex);
        // 路由数据读取
        unsigned long size = 0;
        uint8_t *data = getsectiondata(header, "__DATA", sectionName.UTF8String, &size);
        if (!data || size == 0) {
            // 未读到路由数据则跳过
            continue;
        }
        SFRouterInfo *items = (SFRouterInfo *)data;
        uint32_t infoCount = (uint32_t)(size / sizeof(SFRouterInfo));
        for (uint32_t infoIndex = 0; infoIndex < infoCount; ++infoIndex) {
            SFRouterInfo routerInfo = items[infoIndex];
            SFRouterKey routerInfoKey = [NSString stringWithUTF8String:routerInfo.key];
            
            if (!checkKey(routerInfoKey, [NSString stringWithUTF8String:routerInfo.filePath])) {
                continue; // routerKey校验失败，跳过余下逻辑
            }
            
            SFRouterInfoItem *infoItem = [SFRouterInfoItem new];
            infoItem.key = routerInfoKey;
            infoItem.keyDescription = routerInfo.keyDescription;
            infoItem.filePath = [NSString stringWithUTF8String:routerInfo.filePath];
            infoItem.lineNum = infoItem.lineNum;
            infoItem.className = [self classNameFromMethod:routerInfo.method];
            infoItem.isAction = routerInfo.isAction;
            infoItem.selName = [NSString stringWithUTF8String:routerInfo.selName];
            infoItem.returnTypeName = [NSString stringWithUTF8String:routerInfo.returnTypeName];
            infoItem.returnTypeEncoding = [NSString stringWithUTF8String:routerInfo.returnTypeEncoding];
            infoItem.paramsCount = routerInfo.paramsCount;
            
            NSMutableArray *paramItems = [NSMutableArray arrayWithCapacity:infoItem.paramsCount];
            for (NSUInteger paramIndex = 0; paramIndex < infoItem.paramsCount; ++paramIndex) {
                SFRouterParam param = routerInfo.params[paramIndex];
                
                SFRouterParamItem *paramItem = [SFRouterParamItem new];
                paramItem.name = [NSString stringWithUTF8String:param.name];
                paramItem.typeName = [NSString stringWithUTF8String:param.typeName];
                paramItem.typeEncoding = [NSString stringWithUTF8String:param.typeEncoding];
                paramItem.isRequire = param.isRequire;
                
                [paramItems addObject:paramItem];
            }
            
            infoItem.params = [paramItems copy];
            
            readerInfoItem(routerInfoKey, infoItem);
        }
    }
}

- (NSString *)classNameFromMethod:(char const *)method {
    NSString *_method = [NSString stringWithUTF8String:method];
    NSUInteger firstEmptyIndex = [_method rangeOfString:@" "].location;
    
    NSString *className = [_method substringWithRange:NSMakeRange(2, firstEmptyIndex - 2)];
    return className;
}

@end
