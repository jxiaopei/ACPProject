//
//  NSArray+MDP.h
//  MDPFramework
//
//  Created by 谢进展 on 14-4-6.
//  Copyright (c) 2014年 谢进展. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MDF)

//随机
- (NSArray *)mdf_randomArray;
- (NSArray *)mdf_randomArrayWithLimit:(NSUInteger)itemLimit;
- (id)mdf_randomObject;

//安全
- (id)mdf_safeObjectAtIndex:(NSUInteger)index;

// 数组转换为json
- (NSString*)mdf_jsonValue;

@end
