//
//  NSString+InsertYMD.h
//  LotteryClient
//
//  Created by Dick on 2017/7/6.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (InsertYMD)

- (NSString *)insertDateUnitWithCN;

- (NSString *)insertStandardTimeFormat;

- (NSString *)insertStandardTimeFormatWithCN;

- (NSString *)insertStandardTimeFormatWithIntegral;

@end
