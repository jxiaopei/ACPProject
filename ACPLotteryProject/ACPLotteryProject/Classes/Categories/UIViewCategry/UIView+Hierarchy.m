//
//  UIView+Hierarchy.m
//  XiaoPeng
//
//  Created by whj on 15/11/28.
//  Copyright © 2015年 whj. All rights reserved.
//

#import "UIView+Hierarchy.h"

@implementation UIView (Hierarchy)

/** 返回一个 XML的字符串*/
+ (NSString *)digView:(UIView *)view
{
    if ([view isKindOfClass:[UITableViewCell class]]) return @"";
    // 1.初始化
    NSMutableString *xml = [NSMutableString string];
    
    // 2.标签开头
    [xml appendFormat:@"<%@ frame=\"%@\"", view.class, NSStringFromCGRect(view.frame)];
    if (!CGPointEqualToPoint(view.bounds.origin, CGPointZero)) {
        [xml appendFormat:@" bounds=\"%@\"", NSStringFromCGRect(view.bounds)];
    }
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *)view;
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, scroll.contentInset)) {
            [xml appendFormat:@" contentInset=\"%@\"", NSStringFromUIEdgeInsets(scroll.contentInset)];
        }
    }
    
    // 3.判断是否要结束
    if (view.subviews.count == 0) {
        [xml appendString:@" />"];
        return xml;
    } else {
        [xml appendString:@">"];
    }
    
    // 4.遍历所有的子控件
    for (UIView *child in view.subviews) {
        NSString *childXml = [self digView:child];
        [xml appendString:childXml];
    }
    
    // 5.标签结尾
    [xml appendFormat:@"</%@>", view.class];
    
    //真机 或者 模拟器 将文件 写到 沙盒下
    if (TARGET_OS_SIMULATOR || TARGET_OS_IPHONE) {
        //保存的 指定的路径下
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"View层级结构XML文件的路径==%@",path);
        //@"/Users/aplle/Documents/window.xml"
        [xml writeToFile:path atomically:YES];

    }
    
    
    return xml;
}


@end
