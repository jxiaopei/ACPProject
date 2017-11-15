//
//  ACPTrendViewController.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/3.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBaseViewController.h"
#import "ACPMainPageLotteryDataModel.h"

@interface ACPTrendViewController : ACPBaseViewController

@property(nonatomic,strong)NSArray <ACPMainPageLotteryDataModel *>*titleArr;
@property(nonatomic,copy)NSString *lotteryId;
@property(nonatomic,copy)NSString *lotteryName;

@end
