//
//  ACPMainPageDataModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACPMainPageLotteryDataModel.h"
#import "ACPBannerDataModel.h"
#import "ACPAdvertimentModel.h"

@interface ACPMainPageDataModel : NSObject

@property(nonatomic,copy)NSArray <ACPMainPageLotteryDataModel *>*lottery_game_list;
@property(nonatomic,copy)NSString *lottery_community;
@property(nonatomic,copy)NSArray <ACPAdvertimentModel *>*lottery_activity;
@property(nonatomic,copy)NSString *lottery_trend_chart;
@property(nonatomic,copy)NSString *lottery_information;
@property(nonatomic,copy)NSString *open_lottery;
@property(nonatomic,copy)NSArray <ACPBannerDataModel *>*banner;
@property(nonatomic,copy)NSString *marque;


@end
