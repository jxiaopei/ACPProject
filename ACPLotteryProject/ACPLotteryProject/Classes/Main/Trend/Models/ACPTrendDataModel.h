//
//  ACPTrendDataModel.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/4.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPTrendDataModel : NSObject

@property(nonatomic,copy)NSString *lottery_result;
@property(nonatomic,assign)NSInteger fpNumber;
@property(nonatomic,assign)NSInteger lCount;
@property(nonatomic,assign)NSInteger smallCount;
@property(nonatomic,copy)NSString *endSize;
@property(nonatomic,copy)NSString *lottery_nper;
@property(nonatomic,copy)NSString *size;
@property(nonatomic,assign)NSInteger hCount;
@property(nonatomic,assign)NSInteger bigCount;
@property(nonatomic,assign)NSInteger bothCount;
@property(nonatomic,strong)NSArray *lh;
@property(nonatomic,assign)NSInteger singleCount;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *single;
@property(nonatomic,copy)NSString *sum;
@property(nonatomic,assign)NSInteger pCount;
@property(nonatomic,copy)NSString *firstThere;
@property(nonatomic,copy)NSString *middleThere;
@property(nonatomic,copy)NSString *laterThere;
@property(nonatomic,copy)NSString *up;
@property(nonatomic,copy)NSString *fiveXin;


@end
