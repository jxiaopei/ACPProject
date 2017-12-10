//
//  ACPBaseTabBarController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBaseTabBarController.h"
#import "ACPMainPageViewController.h"
#import "ACPDiscoverViewController.h"
#import "ACPRecommendViewController.h"
#import "ACPPersonalViewController.h"
#import "ACPBaseNavigationController.h"

@interface ACPBaseTabBarController ()

@end

@implementation ACPBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
    [[UITabBar appearance] setBarTintColor:GlobalRedColor];
}

-(void)setupViewControllers
{
    ACPMainPageViewController *mainVC = [ACPMainPageViewController new];
    ACPBaseNavigationController *nav = [[ACPBaseNavigationController alloc]initWithRootViewController:mainVC];
    UIImage *homeNorImage = [[UIImage imageNamed:@"home" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIImage *homeSelImage = [[UIImage imageNamed:@"home_selected" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"首页" image:homeNorImage selectedImage:homeSelImage];
    
    ACPRecommendViewController *recommendVC = [ACPRecommendViewController new];
    ACPBaseNavigationController *nav1 = [[ACPBaseNavigationController alloc]initWithRootViewController:recommendVC  ];
    UIImage *newsNorImage = [[UIImage imageNamed:@"news" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIImage *newsSelImage = [[UIImage imageNamed:@"news_selected" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"推荐" image:newsNorImage selectedImage:newsSelImage];
    
    ACPDiscoverViewController *discoverVC = [ACPDiscoverViewController new];
    ACPBaseNavigationController *nav2 = [[ACPBaseNavigationController alloc]initWithRootViewController:discoverVC];
    UIImage *staNorImage =  [[UIImage imageNamed:@"hm" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIImage *staSelImage = [[UIImage imageNamed:@"hm_selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"发现" image:staNorImage selectedImage:staSelImage];
    
    ACPPersonalViewController *personalVC = [ACPPersonalViewController new];
    ACPBaseNavigationController *nav3 = [[ACPBaseNavigationController alloc]initWithRootViewController:personalVC];
    UIImage *personalNorImage = [[UIImage imageNamed:@"personal" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIImage *personalSelImage = [[UIImage imageNamed:@"personal_selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:personalNorImage selectedImage:personalSelImage];
    
    
    self.viewControllers = @[nav,nav1,nav2,nav3];
    self.tabBar.tintColor = [UIColor whiteColor];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 49)];
    backView.backgroundColor = GlobalRedColor;
    [self.tabBar insertSubview:backView atIndex:0];
    self.selectedIndex = 0;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName ,nil]forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName ,nil]forState:UIControlStateSelected];
}

- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


@end
