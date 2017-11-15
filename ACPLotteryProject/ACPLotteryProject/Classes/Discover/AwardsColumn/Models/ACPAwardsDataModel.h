//
//  ACPAwardsDataModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/6.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPAwardsDataModel : NSObject

@property(nonatomic,copy)NSString *lottery_name;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *platform_name;
@property(nonatomic,assign)NSInteger prize_amount;
@property(nonatomic,copy)NSString *result_num;
@property(nonatomic,copy)NSString *skill_content;
@property(nonatomic,copy)NSString *pictures_link;
@property(nonatomic,copy)NSString *skill_title;
@property(nonatomic,copy)NSString *type_id;
@property(nonatomic,copy)NSString *type_name;
@property(nonatomic,copy)NSString *url_link;

@end
