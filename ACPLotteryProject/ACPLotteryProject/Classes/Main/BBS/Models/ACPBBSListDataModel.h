//
//  ACPBBSListDataModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPBBSListDataModel : NSObject

@property (nonatomic,copy) NSString *Id;//帖子的id
@property (nonatomic,copy) NSString *user_id;//帖子发布人的id
@property (nonatomic,copy) NSString *love_count;//点击喜欢总数
@property (nonatomic,copy) NSString *release_content;//发布内容
@property (nonatomic,copy) NSString *release_time;//发布时间
@property (nonatomic,copy) NSString *user_name;//发布用户名称
@property (nonatomic,copy) NSString *user_image_url;//头像
@property (nonatomic,copy) NSString *return_message_count;//回复消息总数
@property (nonatomic,copy) NSString *community_top;//1为置顶
@property (nonatomic,copy) NSString *release_image_url;//全部图片
@property (nonatomic,copy) NSString *user_whether_love;//是否喜欢过
@property (nonatomic,copy) NSString *user_whether_collection;//收藏过
@property (nonatomic,strong) NSArray *return_message_list;//回复的内容
@property (nonatomic,copy) NSString *collection_count;
@property (nonatomic,copy) NSString *deleted;
@property (nonatomic,copy) NSString *desc_time;
@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic,copy) NSString *user_brief_introduction;

@end
