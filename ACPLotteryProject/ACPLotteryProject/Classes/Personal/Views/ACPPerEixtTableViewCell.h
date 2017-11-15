//
//  ACPPerEixtTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPPerEixtTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,assign)BOOL ishiddenBtn;
@property(nonatomic,copy)void(^didClickExitBtnBlock)();

@end
