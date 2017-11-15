//
//  ACPPersonalTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPPersonalTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *detail;

@end
