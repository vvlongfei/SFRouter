//
//  SFTargetViewController.m
//  SFRouter_Example
//
//  Created by longfei on 2020/8/26.
//  Copyright © 2020 longfei. All rights reserved.
//

#import "SFTargetViewController.h"
#import "SFRouter.h"
#import <YYModel/YYModel.h>

@interface SFTargetViewController ()
@property (nonatomic, copy) NSArray<NSString *> *items; ///< 标题
@property (nonatomic, copy) NSDictionary *param; ///< param
@end

@implementation SFTargetViewController

SFRouterRegisterPage(@"目标页面", target, (NSString *)title, (NSArray *)items, (NSDictionary *)param, (NSInteger)age) {
    self = [super init];
    if (self) {
        self.title = title;
//        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.items = items;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.greenColor;
    // Do any additional setup after loading the view.
    
    NSMutableArray<UILabel *> *labels = [NSMutableArray array];
    
//    self.view
    for (NSString *title in self.items) {
        UILabel *label = [UILabel new];
        label.text = title;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:label];
        [labels addObject:label];
    }
    
    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [self.view addConstraints:@[
                [obj.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
                [obj.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50]
            ]];
        } else {
            [self.view addConstraints:@[
                [obj.topAnchor constraintEqualToAnchor:labels[idx-1].bottomAnchor constant:10],
                [obj.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50]
            ]];
        }
    } ];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
