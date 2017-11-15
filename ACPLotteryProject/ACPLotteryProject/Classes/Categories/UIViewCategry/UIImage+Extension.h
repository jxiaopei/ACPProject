//
//  UIImage+Extension.h
//  ImFans
//
//  Created by kuang on 15/8/11.
//  Copyright (c) 2015年 YFSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *) imageWithName:(NSString *) imageName;
+ (UIImage *) resizableImageWithName:(NSString *)imageName;
- (UIImage*) scaleImageWithSize:(CGSize)size;

+ (UIImage *) imageWithUIView:(UIView *)view;

+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)leftScale top:(CGFloat)topScale;

+ (UIImage *)resizedImage:(NSString *)name;
@end
