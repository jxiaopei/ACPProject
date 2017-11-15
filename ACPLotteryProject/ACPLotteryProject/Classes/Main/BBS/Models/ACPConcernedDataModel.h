//
//  ACPConcernedDataModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPConcernedDataModel : NSObject

@property (nonatomic,copy) NSString *user_brief_introduction;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *count_fans;
@property (nonatomic,copy) NSString *count_community;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *user_image_url;
@property (nonatomic,copy) NSString *fans_id;
@property (nonatomic,copy) NSString *count_concerned;
@property (nonatomic,copy) NSString *user_phone;
@property (nonatomic,copy) NSString *user_account;
@property (nonatomic,assign) NSInteger user_concerned;
@property (nonatomic,copy) NSString *user_gender;
@property (nonatomic,copy) NSString *add_time;
//@property (nonatomic,assign) BOOL is_user_concerned;
@end
