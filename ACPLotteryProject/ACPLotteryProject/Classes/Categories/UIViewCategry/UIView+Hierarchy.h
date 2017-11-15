//
//  UIView+Hierarchy.h
//  XiaoPeng
//
//  Created by whj on 15/11/28.
//  Copyright © 2015年 whj. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 用来递归 UIView的 层级 关系---便于程序的结构分析*/
@interface UIView (Hierarchy)

/** 返回一个来递归 UIView的 层级 关系的XML的字符串*/
+ (NSString *)digView:(UIView *)view;

@end
