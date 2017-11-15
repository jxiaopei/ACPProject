//
//  ACPNewsListDataModel.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPNewsListDataModel.h"

@implementation ACPNewsListDataModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

@end
