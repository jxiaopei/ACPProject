//
//  UINavigationController+Ext.m
//  paiyipai
//
//  Created by BruceZCQ on 3/17/15.
//  Copyright (c) 2015 BruceZCQ. All rights reserved.
//

#import "UINavigationController+Ext.h"

@implementation UINavigationController (Ext)

#pragma mark - AutoRate

-(BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations {
    NSUInteger support = [[self.viewControllers lastObject] supportedInterfaceOrientations];
    return support;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self && self.viewControllers && self.viewControllers.count == 0) {
        return UIInterfaceOrientationPortrait;
    }
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

#pragma mark - StatusBar

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL) prefersStatusBarHidden
{
    return NO;
}

- (void)_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    //Fade here look nice, no more black shadow stuff
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:nil];
    [self pushViewController:viewController animated:NO];
}

@end
