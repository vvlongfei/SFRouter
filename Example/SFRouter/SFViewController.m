//
//  SFViewController.m
//  SFRouter
//
//  Created by longfei on 08/26/2020.
//  Copyright (c) 2020 longfei. All rights reserved.
//

#import "SFViewController.h"
#import "SFRouter.h"
#import <YYModel/YYModel.h>
//#import <objc/runtime.h>

@interface SFViewController ()

@end

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
	// Do any additional setup after loading the view, typically from a nib.
}

SFRouterUseAction(mainWindow, UIWindow *);

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [action_mainWindow() addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, 100, 100, 50);
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:@"我是按钮哟" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
//    NSString *initFunc = @metamacro_stringify_all(, SFRouterRegisterPage(SFTargetViewController, @"目标页面", target, (NSString *)title, (NSArray *)items));
//    printf([initFunc UTF8String]);
}

//SFRouterUsePage(target, (NSString *)title, (NSArray *)items);

- (void)tapAction:(id)sender {
//    open_target_page(self, @"我来了");
    
    NSData *data = [@"longfei" dataUsingEncoding:(NSUTF8StringEncoding)];
    NSString *url = [NSString stringWithFormat:@"feiyu://target?title=%@", [data base64EncodedStringWithOptions:0]];
    NSArray *titles = @[@"飞羽", @"龙龙", @"天折"];
    NSDictionary *param = @{@"title":@"zheyu"};
    NSString *url2 = [NSString stringWithFormat:@"feiyu://target?title=龙飞&items=%@&param=%@", [titles yy_modelToJSONString], [param yy_modelToJSONString]];;
    
    [SFRouter routerForUrl:url2];
}

SFRouterRegisterAction(SFViewController, @"", sf_alert, void) {
    [[UIApplication sharedApplication].keyWindow addSubview:({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
        view.backgroundColor = [UIColor redColor];
        view;
    })];
}


@end
