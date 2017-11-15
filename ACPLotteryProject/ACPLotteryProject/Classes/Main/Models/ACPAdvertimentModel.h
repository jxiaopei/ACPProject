//
//  ACPAdvertimentModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/11/1.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPAdvertimentModel : NSObject

@property(nonatomic,copy)NSString *act_content;
@property(nonatomic,assign)NSInteger act_id;
@property(nonatomic,assign)NSInteger desc_time;
@property(nonatomic,copy)NSString *act_link_ur;
@property(nonatomic,assign)NSInteger act_type;
@property(nonatomic,copy)NSString *act_name;
@property(nonatomic,copy)NSString *end_time;
@property(nonatomic,assign)NSInteger begin_time;
@property(nonatomic,copy)NSString *act_pic_url;
@property(nonatomic,copy)NSString *act_pic_url_tow;

@end
