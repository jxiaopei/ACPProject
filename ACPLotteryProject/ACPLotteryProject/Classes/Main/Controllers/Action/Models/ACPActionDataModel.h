//
//  ACPActionDataModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPActionDataModel : NSObject

@property(nonatomic,copy)NSString *act_name;//
@property(nonatomic,copy)NSString *act_content;//
@property(nonatomic,copy)NSString *begin_time;//
@property(nonatomic,copy)NSString *desc_time;//
@property(nonatomic,copy)NSString *end_time;//
@property(nonatomic,assign)NSInteger act_type;//
@property(nonatomic,copy)NSString *act_pic_url;//
@property(nonatomic,copy)NSString *act_link_url;//
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,assign)NSInteger act_id;//
@property(nonatomic,copy)NSString *act_type_name;

@end
