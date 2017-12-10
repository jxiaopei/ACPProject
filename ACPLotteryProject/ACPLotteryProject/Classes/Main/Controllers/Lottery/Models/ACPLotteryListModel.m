//
//  ACPLotteryListModel.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPLotteryListModel.h"

@implementation ACPLotteryListModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"lottery_result":[ACPLotteryDataModel class]};
}

-(CGFloat)rowHeight{
    if([_lottery_name isEqualToString:@"北京快乐8"]){
        return (SCREENWIDTH - 85)/10 * 3  + 3 + 60;
    }else{
        if([_lottery_extra_0 isNotNil]){
          return (SCREENWIDTH - 85)/10 * 2 + 60;
        }else{
          return (SCREENWIDTH - 85)/10 * 2 + 30;
        }
    }
}

-(CGFloat)typeRowHeight{
    if([_lottery_name isEqualToString:@"北京快乐8"]){
        return (SCREENWIDTH - 85)/10 * 3  + 3 + 60;
    }else{
        return (SCREENWIDTH - 85)/10 * 2 + 60;
    }
}

- (void)countSeconds {
    _lottery_next_time--;
}

- (NSString *)timeString {
    NSInteger times = _lottery_next_time;
    if (times <= 0) {
        return @"00:00";
    }else if (times <= 600){
        return [NSString stringWithFormat:@"%02ld分%02ld秒",
                (long)(times % 3600 / 60), (long)(times  % 60)];
    }else {
        return [NSString stringWithFormat:@"%02ld时%02ld分%02ld秒",
                (long)(times / 3600), (long)(times % 3600 / 60), (long)(times  % 60)];
    }
}

@end
