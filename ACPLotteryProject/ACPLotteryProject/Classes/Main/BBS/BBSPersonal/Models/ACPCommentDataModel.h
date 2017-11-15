//
//  ACPCommentDataModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPCommentDataModel : NSObject

@property(nonatomic,assign)NSInteger b_community_id;
@property(nonatomic,copy)NSString *return_time;
@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,copy)NSString *return_content;
@property(nonatomic,assign)NSString *user_id;
@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,assign)NSInteger desc_time;
@property(nonatomic,copy)NSString *deleted;
@property(nonatomic,copy)NSString *user_image_url;

@end
