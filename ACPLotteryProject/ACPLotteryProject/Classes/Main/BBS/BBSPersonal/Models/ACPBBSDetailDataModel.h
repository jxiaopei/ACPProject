//
//  ACPBBSDetailDataModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACPCommentDataModel.h"

@interface ACPBBSDetailDataModel : NSObject

@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *release_content;
@property(nonatomic,strong)NSArray <ACPCommentDataModel *>*return_message_list;
@property(nonatomic,copy)NSString *release_image_url;
@property(nonatomic,copy)NSString *user_image_url;
@property(nonatomic,copy)NSString *release_time;
@property(nonatomic,assign)NSInteger desc_time;
@property(nonatomic,copy)NSString *user_Id;
@property(nonatomic,copy)NSString *deleted;
@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,assign)NSInteger user_whether_love;
@property(nonatomic,assign)NSInteger user_whether_collection;
@property(nonatomic,assign)CGFloat rowHeight;

@end
