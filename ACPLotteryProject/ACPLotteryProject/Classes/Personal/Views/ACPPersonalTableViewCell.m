//
//  ACPPersonalTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPPersonalTableViewCell.h"

@implementation ACPPersonalTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        _iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(20);
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
        }];
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(0);
        }];
        titleLabel.font = [UIFont systemFontOfSize:13];
        
        
        UILabel *detailLabel = [UILabel new];
        [self addSubview:detailLabel];
        _detailLabel = detailLabel;
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-30);
        }];
        detailLabel.font = [UIFont systemFontOfSize:11];
        detailLabel.textColor = [UIColor grayColor] ;
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
    _detailLabel.text = _detail;
    _iconView.image = [UIImage imageNamed:title];
}

@end
