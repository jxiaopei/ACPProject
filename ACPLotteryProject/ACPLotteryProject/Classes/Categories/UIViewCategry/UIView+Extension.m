//
//  UIView+Extension.m
//  ImFans
//
//  Created by kuang on 15/8/11.
//  Copyright (c) 2015年 YFSS. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (void)setX_X:(CGFloat)x_X
{
    CGRect frame = self.frame;
    frame.origin.x = x_X;
    self.frame = frame;
}

- (CGFloat)x_X
{
    return self.frame.origin.x;
}

- (void)setY_Y:(CGFloat)y_Y
{
    CGRect frame = self.frame;
    frame.origin.y = y_Y;
    self.frame = frame;
}

- (CGFloat)y_Y
{
    return self.frame.origin.y;
}

- (void)setWidth_W:(CGFloat)width_W
{
    CGRect frame = self.frame;
    frame.size.width = width_W;
    self.frame = frame;
}

- (CGFloat)width_W
{
    return self.frame.size.width;
}

- (void)setHeight_H:(CGFloat)height_H
{
    CGRect frame = self.frame;
    frame.size.height = height_H;
    self.frame = frame;
}

- (void)setCenterX_CX:(CGFloat)centerX_CX
{
    CGPoint center = self.center;
    center.x = centerX_CX;
    self.center = center;
}

- (CGFloat)centerX_CX
{
    return self.center.x;
}
- (void)setCenterY_CY:(CGFloat)centerY_CY
{
    CGPoint center = self.center;
    center.y = centerY_CY;
    self.center = center;
}

- (CGFloat)centerY_CY
{
    return self.center.y;
}

- (CGFloat)height_H
{
    return self.frame.size.height;
}

- (void)setSize_S:(CGSize)size_S
{
    CGRect frame = self.frame;
    frame.size = size_S;
    self.frame = frame;
}

- (CGSize)size_S
{
    return self.frame.size;
}





#pragma mark Frame Borders

- (CGFloat)left_L
{
    return self.x_X;
}

- (void)setLeft_L:(CGFloat)left_L
{
    self.x_X = left_L;
}

- (CGFloat)right_R
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight_R:(CGFloat)right_R
{
    self.x_X = right_R - self.width_W;
}

- (CGFloat)top_T
{
    return self.y_Y;
}

- (void)setTop_T:(CGFloat)top_T
{
    self.y_Y = top_T;
}

- (CGFloat)bottom_B
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom_B:(CGFloat)bottom_B
{
    self.y_Y = bottom_B - self.height_H;
}





@end
