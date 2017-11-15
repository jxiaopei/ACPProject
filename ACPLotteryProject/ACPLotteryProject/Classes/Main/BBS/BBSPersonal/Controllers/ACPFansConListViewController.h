//
//  ACPFansConListViewController.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/21.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBaseViewController.h"

typedef NS_ENUM(NSInteger,FansConcernedListType){
    
    FansType        = 0, //粉丝
    ConcernedType,       //关注
};


@interface ACPFansConListViewController : ACPBaseViewController

@property(nonatomic,assign)FansConcernedListType listType;
@property(nonatomic,copy)NSString *userId;

@end
