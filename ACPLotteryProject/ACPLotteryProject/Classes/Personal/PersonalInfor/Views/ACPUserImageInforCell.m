//
//  ACPUserImageInforCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPUserImageInforCell.h"

@implementation ACPUserImageInforCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        _iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(60);
            make.right.mas_equalTo(-30);
            make.centerY.mas_equalTo(-5);
        }];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 30;
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(-5);
        }];
        titleLabel.font = [UIFont systemFontOfSize:13];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
        lineView.backgroundColor = GlobalLightGreyColor;
    
    }
    return self;
}


@end
