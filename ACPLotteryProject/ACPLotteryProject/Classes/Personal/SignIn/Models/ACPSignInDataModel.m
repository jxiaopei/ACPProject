//
//  ACPSignInDataModel.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPSignInDataModel.h"

@implementation ACPSignInDataModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

@end
