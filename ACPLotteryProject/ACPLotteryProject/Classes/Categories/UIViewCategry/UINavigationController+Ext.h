//
//  UINavigationController+Ext.h
//  paiyipai
//
//  Created by BruceZCQ on 3/17/15.
//  Copyright (c) 2015 BruceZCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Ext)

- (void)_pushViewController:(UIViewController *)viewController
                   animated:(BOOL)animated;

@end
