//
//  UIImage+Extension.m
//  ImFans
//
//  Created by kuang on 15/8/11.
//  Copyright (c) 2015年 YFSS. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  争对ios7以上的系统适配新的图片资源
 *
 *  @param imageName 图片名称
 *
 *  @return 新的图片
 */
+ (UIImage *)imageWithName:(NSString *)imageName
{
    UIImage *newImage = nil;
//    if () {
//        newImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_os7"]];
//    }
//    if (newImage == nil) {
//        newImage = [UIImage imageNamed:imageName];
//    }
    
    newImage = [UIImage imageNamed:imageName];
    return newImage;
    
}
+ (UIImage *)resizableImageWithName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    // 获取原有图片的宽高的一半
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    
    return newImage;
}

/**
 *  实现图片的缩小或者放大
 *
 *  @param size  大小范围
 *
 *  @return 新的图片
 */

-(UIImage*) scaleImageWithSize:(CGSize)size
{
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

+ (UIImage *) imageWithUIView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)leftScale top:(CGFloat)topScale
{
    // 1.加载图片
    UIImage *image = [UIImage imageNamed:name];
    
    // 2.左边多少内容需要保护
    CGFloat left = image.size.width * leftScale;
    // 3.顶部多少内容需要保护
    CGFloat top = image.size.height * topScale;
    
    // 4.这个方法只会拉伸中间的1x1区域
    return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name left:0.5 top:0.5];
}


@end
