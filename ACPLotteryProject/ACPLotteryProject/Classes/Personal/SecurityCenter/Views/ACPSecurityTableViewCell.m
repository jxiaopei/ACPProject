//
//  ACPSecurityTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPSecurityTableViewCell.h"

@implementation ACPSecurityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(8);
        }];
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *detailLabel = [UILabel new];
        [self addSubview:detailLabel];
        _detailLabel =detailLabel;
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-5);
        }];
        detailLabel.font = [UIFont systemFontOfSize:11];
        detailLabel.textColor = [UIColor grayColor];
        
    }
    return self;
}



@end
