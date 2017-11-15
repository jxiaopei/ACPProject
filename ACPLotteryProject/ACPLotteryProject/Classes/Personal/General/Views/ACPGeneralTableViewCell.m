//
//  ACPGeneralTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/1.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPGeneralTableViewCell.h"

@implementation ACPGeneralTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
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

@end
