//
//  ACPIntegralDetailModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/10.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPIntegralDetailModel : NSObject

@property(nonatomic,copy)NSString *credit_amount;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,copy)NSString *tb_name_from;
@property(nonatomic,copy)NSString *site_code;
@property(nonatomic,copy)NSString *before_credit;
@property(nonatomic,assign)NSInteger operation_type;
@property(nonatomic,copy)NSString *site_name;
@property(nonatomic,copy)NSString *user_site_id;
@property(nonatomic,assign)NSInteger mission_type;
@property(nonatomic,copy)NSString *user_account;
@property(nonatomic,copy)NSString *mission_name;
@property(nonatomic,copy)NSString *mission_point;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *after_credit;
@property(nonatomic,assign)NSInteger trans_type;

@end
