//
//  ACPRecommendModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPRecommendModel : NSObject

@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *link_url;
@property (nonatomic, strong) NSString *show_flag;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type_name;

@end
