//
//  ACPTrendListTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/4.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPTrendListTableViewCell.h"

@implementation ACPTrendListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(80);
        }];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.adjustsFontSizeToFitWidth = YES;
        
        UILabel *timeLabel = [UILabel new];
        [self addSubview: timeLabel];
        _timeLabel = timeLabel;
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(60);
        }];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.adjustsFontSizeToFitWidth = YES;
        
        UILabel *numLabel = [UILabel new];
        [self addSubview:numLabel];
        _numLabel = numLabel;
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
//            make.centerX.mas_equalTo(30);
            make.right.mas_equalTo(-10);
            make.left.mas_equalTo(80);
        }];
        numLabel.font = [UIFont systemFontOfSize: 13];
        numLabel.textColor = [UIColor blackColor];
        numLabel.adjustsFontSizeToFitWidth = YES;
        numLabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        lineView.backgroundColor = GlobalLightGreyColor;
    }
    return self;
}

@end
