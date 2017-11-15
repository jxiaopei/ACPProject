//
//  ACPCleanCacheManager.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/1.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^cleanCacheBlock)();

@interface ACPCleanCacheManager : NSObject

/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block;
/**
 *  整个缓存目录的大小
 */
+(float)folderSizeAtPath;

@end
