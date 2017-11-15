//
//  ACPConcernedNoDataCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPConcernedNoDataCell.h"

@implementation ACPConcernedNoDataCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.height.width.mas_equalTo(63);
        }];
        imageView.image = [UIImage imageNamed:@"没有关注"];
        
        UILabel *statusLabel = [UILabel new];
        [self addSubview:statusLabel];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(5);
        }];
        statusLabel.text = @"您还没有关注其他人";
        statusLabel.font = [UIFont systemFontOfSize:14];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(2);
        }];
        lineView.backgroundColor = GlobalLightGreyColor;
        
    }
    return self;
}

@end
