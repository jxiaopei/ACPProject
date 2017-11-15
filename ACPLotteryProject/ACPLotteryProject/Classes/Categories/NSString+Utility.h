//
//  NSString+Utility.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

// 验证字符串是否为空
- (BOOL)isNotNil;

// mdf5
- (NSString *)mdf_md5;

-(NSString *) md5HexDigest;

+ (NSString *) md5:(NSString *) input;

@end
