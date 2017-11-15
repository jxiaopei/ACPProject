//
//  ACPRecommendConDataModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPRecommendConDataModel : NSObject

@property (nonatomic,copy) NSString *user_brief_introduction;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *count_fans;
@property (nonatomic,copy) NSString *count_community;
@property (nonatomic,assign) NSInteger user_concerned;
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *user_image_url;

@end
