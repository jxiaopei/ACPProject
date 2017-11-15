//
//  NSString+InsertYMD.m
//  LotteryClient
//
//  Created by Dick on 2017/7/6.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "NSString+InsertYMD.h"

@implementation NSString (InsertYMD)

- (NSString *)insertDateUnitWithCN {
    NSMutableString *str = [[NSMutableString alloc] initWithString:self];
    [str insertString:@"年" atIndex:4];
    [str insertString:@"月" atIndex:7];
    [str appendString:@"日"];
    return str;
}

- (NSString *)insertStandardTimeFormat {
    NSMutableString *str = [[NSMutableString alloc] initWithString:self];
    [str insertString:@"-" atIndex:4];
    [str insertString:@"-" atIndex:7];
    [str insertString:@" " atIndex:10];
    [str insertString:@":" atIndex:13];
    [str insertString:@":" atIndex:16];
    return str;
}

- (NSString *)insertStandardTimeFormatWithCN {
    NSMutableString *str = [[NSMutableString alloc] initWithString:self];
    [str insertString:@"年" atIndex:4];
    [str insertString:@"月" atIndex:7];
    [str insertString:@"日 " atIndex:10];
    [str insertString:@":" atIndex:14];
    [str insertString:@":" atIndex:17];
    return str;
}

- (NSString *)insertStandardTimeFormatWithIntegral {
    NSMutableString *str = [[NSMutableString alloc] initWithString:self];
    [str insertString:@"." atIndex:4];
    [str insertString:@"." atIndex:7];
    [str insertString:@". " atIndex:10];
    [str insertString:@":" atIndex:14];
    return str;
}

@end
