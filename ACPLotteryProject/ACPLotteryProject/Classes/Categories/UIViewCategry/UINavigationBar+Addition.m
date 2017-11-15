//
//  UINavigationBar+Addition.m
//  UINavigationBar+Addition
//
//  Created by Junda on 14/3/14.
//  Copyright (c) 2014 Just2us. All rights reserved.
//

#import "UINavigationBar+Addition.h"

@implementation UINavigationBar (Addition)

/**
 * Hide 1px hairline of the nav bar
 */
- (void)hideBottomHairline {
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self];
    navBarHairlineImageView.hidden = YES;

//    [[self viewWithTag:10121012] removeFromSuperview];
}

/**
 * Show 1px hairline of the nav bar
 */
- (void)showBottomHairline {
    // Show 1px hairline of translucent nav bar
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self];
    navBarHairlineImageView.hidden = NO;
//    [self bottomHailineImage:kMeetThemeColorImage heightOffset:1.0f];
}

- (void)bottomHailineImage:(UIImage *)image
              heightOffset:(CGFloat)heightOffset
{
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self];
    navBarHairlineImageView.hidden = YES;
    CGRect frame = navBarHairlineImageView.frame;
    frame.size.height += heightOffset;
    frame.origin.y = 44;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = frame;
    imageView.tag = 10121012;
    [self addSubview:imageView];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
