//
//  ACPBaseNavigationController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBaseNavigationController.h"

@interface ACPBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ACPBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = GlobalRedColor;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.interactivePopGestureRecognizer.delegate =self;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
