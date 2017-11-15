//
//  LCNetDataParsing.h
//  LotteryClient
//
//  Created by Dick on 2017/7/3.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCNetDataParsing : NSObject

+ (NSString *)inputParsing:(NSDictionary *)dict;

+(NSString *)inputImageParsing:(NSDictionary *)dict;

+ (NSDictionary *)outputParsing:(id)responseObject;

+ (NSDictionary *)outputImageParsing:(id)responseObject;

@end
