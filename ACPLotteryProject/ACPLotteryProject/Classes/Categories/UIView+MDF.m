//
//  UIView+MDF.m
//  MDFFramework
//
//  Created by 谢进展 on 14-4-5.
//  Copyright (c) 2014年 谢进展. All rights reserved.
//

#import "UIView+MDF.h"
#import <objc/runtime.h>

@implementation UIView (MDF)

@end

@implementation UIView (MDF_FrameAddition)

- (CGSize)size {
   return self.frame.size;

}

- (CGFloat)cx
{
    return self.center.x;
}

- (CGFloat)cy
{
    return self.center.y;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCx:(CGFloat)cx
{
    CGPoint center = self.center;
    center.x = cx;
    self.center = center;
}

- (void)setCy:(CGFloat)cy
{
    CGPoint center = self.center;
    center.y = cy;
    self.center = center;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setLeft:(CGFloat)left
{
    CGRect ori = self.frame;
    ori.origin.x = left;
    self.frame = ori;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGFloat left = right - self.width;
    [self setLeft:left];
}

- (CGFloat)right
{
    return self.left + self.width;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom
{
    CGFloat top = bottom - self.height;
    [self setTop:top];
}

- (CGFloat)bottom
{
    return self.top + self.height;
}

@end


@implementation UIView (MDF_Utility)

- (UIImage *)mdf_screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (void)mdf_recursiveEnumerateViewsUsingBlock:(void (^)(UIView *subView, UIView* superView, BOOL *stop))block
{
    if (block == NULL) {
        return;
    }
    
    for (UIView *subview in self.subviews) {
        BOOL stop = NO;
        block(subview,self,&stop);
        if (stop) {
            break;
        }
    }
}

static char kWhenTappedBlockKey;
static char kWhenDoubleTappedBlockKey;
static char kWhenLongPressedBlockKey;

#pragma mark -
#pragma mark Set blocks

- (void)_runBlockForKey:(void *)blockKey forGesture:(UIGestureRecognizer *)tapGesture{
    MDFGestureRecognizerActionBlock block = objc_getAssociatedObject(self, blockKey);
    if (block) block(tapGesture);
}

- (void)_setBlock:(MDFGestureRecognizerActionBlock)block forKey:(void *)blockKey {
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)mdf_whenSingleTapped:(MDFGestureRecognizerActionBlock )block
{
    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(_viewWasTapped:)];
    gesture.cancelsTouchesInView = NO;//view会和手势同时响应触摸序列
    [self _addRequiredToDoubleTapsRecognizer:gesture];
    [self _setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)mdf_whenDoubleTapped:(MDFGestureRecognizerActionBlock )block
{
    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(_viewWasDoubleTapped:)];
    gesture.cancelsTouchesInView = NO;
    [self _addRequiredToDoubleTapsRecognizer:gesture];
    [self _setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)mdf_whenLongPressed:(MDFGestureRecognizerActionBlock )block
{
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPressed:)];
    gesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:gesture];
    [self _setBlock:block forKey:&kWhenLongPressedBlockKey];
    
}

- (void)_longPressed:(UILongPressGestureRecognizer *)longGesture
{
    [self _runBlockForKey:&kWhenLongPressedBlockKey forGesture:longGesture];
}

- (void)_viewWasDoubleTapped:(UITapGestureRecognizer *)tap
{
    [self _runBlockForKey:&kWhenDoubleTappedBlockKey forGesture:tap];
}

- (void)_viewWasTapped:(UITapGestureRecognizer *)tap
{
    [self _runBlockForKey:&kWhenTappedBlockKey forGesture:tap];
}

#pragma mark -
#pragma mark Helpers

- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector {
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    
    return tapGesture;
}

- (void)_addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer {
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 1 && tapGesture.numberOfTapsRequired == 1) {
                [tapGesture requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}

- (void)_addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer {
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                [recognizer requireGestureRecognizerToFail:tapGesture];//tapGesture侦测失败，才会触发recognizer
            }
        }
    }
}

- (UIView *)mdf_firstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView mdf_firstResponder];
        if (responder) return responder;
    }
    return nil;
}

- (UIView *)mdf_copy
{
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: self];
    id clone = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return clone;
}

+ (UIViewAnimationOptions)mdf_animationOptionsWithCurve:(UIViewAnimationCurve)curve
{
    if (curve == UIViewAnimationCurveEaseInOut) {
        return UIViewAnimationOptionCurveEaseInOut;
    } else if (curve == UIViewAnimationCurveEaseIn) {
        return UIViewAnimationOptionCurveEaseIn;
    } else if (curve == UIViewAnimationCurveEaseOut) {
        return UIViewAnimationOptionCurveEaseOut;
    }
    return UIViewAnimationOptionCurveLinear;
}

- (void)mdf_logSubviewsInfo
{
#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    //view的私有方法
    if ([self respondsToSelector:@selector(recursiveDescription)]){
        [self performSelector:@selector(recursiveDescription) withObject:nil];
    }
    #pragma clang diagnostic pop
#endif
}

- (void)mdf_setAnchorPoint:(CGPoint)anchorPoint
{
    CGRect frame = self.frame;
    self.layer.anchorPoint = anchorPoint;
    self.frame = frame;
}

@end
