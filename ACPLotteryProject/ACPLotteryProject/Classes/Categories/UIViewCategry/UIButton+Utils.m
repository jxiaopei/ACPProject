//
//  UIButton+Utils.m
//  Meet
//
//  Created by BruceZCQ on 12/19/14.
//  Copyright (c) 2014 BruceZCQ. All rights reserved.
//

#import "UIButton+Utils.h"

@implementation UIButton (Utils)

- (void)setNormalTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setSelectTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateSelected];
}

- (void)setDisableTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateDisabled];
}

- (void)setNormalTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setSelectTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateSelected];
}

- (void)setDisableTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateSelected];
}

- (void)setNomalImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setDisableImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateDisabled];
}

- (void)setSelectImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateSelected];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setSelectBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

- (void)setLabelFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target
             action:action
   forControlEvents:UIControlEventTouchUpInside];
}

@end
