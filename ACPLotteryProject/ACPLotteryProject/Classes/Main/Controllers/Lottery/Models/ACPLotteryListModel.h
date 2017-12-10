//
//  ACPLotteryListModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACPLotteryDataModel.h"

@interface ACPLotteryListModel : NSObject

@property (nonatomic,copy) NSString *c_time;
@property (nonatomic,copy) NSString *lottery_nper;
@property (nonatomic,copy) NSString *lottery_name;
@property (nonatomic,copy) NSString *lottery_url;
@property (nonatomic,copy) NSString *lottery_image_url;
@property (nonatomic,copy) NSString *lottery_game_id;
@property (nonatomic,copy) NSString *gmid;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,strong) NSArray <ACPLotteryDataModel *>*lottery_result;
@property (nonatomic,assign) NSInteger lottery_next_time;
@property (nonatomic,assign)NSInteger lottery_delay_time;
@property (nonatomic,copy) NSString *lottery_extra_0;
@property (nonatomic,assign)NSInteger lottery_period;
@property (nonatomic,assign)NSInteger lottery_state;
@property (nonatomic,assign)NSInteger reply_count;
@property (nonatomic,copy) NSString *lottery_trend_chart_link;
@property (nonatomic,assign)CGFloat rowHeight;
@property (nonatomic,assign)CGFloat typeRowHeight;
@property (nonatomic,assign)NSInteger indexNumber;
//@property (nonatomic, assign) BOOL kaijiang;
//@property (nonatomic, assign) BOOL opened;


- (void)countSeconds;

- (NSString *)timeString;

@end
