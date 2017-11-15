//
//  ACPMainPageDataModel.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPMainPageDataModel.h"

@implementation ACPMainPageDataModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"lottery_game_list":[ACPMainPageLotteryDataModel class],@"banner":[ACPBannerDataModel class],@"lottery_activity":[ACPAdvertimentModel class]};
}

@end
