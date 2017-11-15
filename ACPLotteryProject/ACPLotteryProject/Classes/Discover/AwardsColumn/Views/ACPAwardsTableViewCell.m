//
//  ACPAwardsTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/6.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPAwardsTableViewCell.h"

@interface ACPAwardsTableViewCell ()

@property(nonatomic,strong)UILabel *awardsLabel;
@property(nonatomic,strong)UILabel *lotteryLabel;
@property(nonatomic,strong)UILabel *periodLabel;
@property(nonatomic,strong)UILabel *contentLabel;

@end

@implementation ACPAwardsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *verLine = [UIView new];
        [self addSubview:verLine];
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.left.mas_equalTo( 120 );
            make.centerY.mas_equalTo(-5);
            make.width.mas_equalTo(0.5);
        }];
        verLine.backgroundColor = [UIColor grayColor];
        
        UILabel *awardsLabel = [UILabel new];
        [self addSubview:awardsLabel];
        _awardsLabel = awardsLabel;
        [awardsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-100);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(verLine.mas_left).mas_offset(-5);
        }];
        awardsLabel.font = [UIFont systemFontOfSize:18];
        awardsLabel.text = @"xx万";
        awardsLabel.textColor = [UIColor redColor];
        awardsLabel.adjustsFontSizeToFitWidth = YES;
        awardsLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *lotteryLabel = [UILabel new];
        [self addSubview:lotteryLabel];
        _lotteryLabel = lotteryLabel;
        [lotteryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(awardsLabel);
            make.top.mas_equalTo(awardsLabel.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(verLine.mas_left).mas_offset(-5);
        }];
        lotteryLabel.textColor = [UIColor grayColor];
        lotteryLabel.font = [UIFont systemFontOfSize:13];
        lotteryLabel.text = @"彩票类型";
        lotteryLabel.adjustsFontSizeToFitWidth = YES;
        lotteryLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *periodLabel = [UILabel new];
        [self addSubview:periodLabel];
        _periodLabel = periodLabel;
        [periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(awardsLabel);
            make.top.mas_equalTo(lotteryLabel.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(verLine.mas_left).mas_offset(-5);
        }];
        periodLabel.text = @"第xxxxxx期";
        periodLabel.adjustsFontSizeToFitWidth = YES;
        periodLabel.font = [UIFont systemFontOfSize:13];
        periodLabel.textColor = [UIColor grayColor];
        periodLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *contentLabel = [UILabel new];
        [self addSubview:contentLabel];
        _contentLabel = contentLabel;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(verLine.mas_right).mas_offset(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.numberOfLines = 2;
        
        UIButton *nextBtn = [UIButton new];
        [self addSubview:nextBtn];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-20);
        }];
        [nextBtn setTitle:@"详情 >" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
        lineView.backgroundColor = GlobalLightGreyColor;
        
    }
    
    return self;
}

-(void)setDataModel:(ACPAwardsDataModel *)dataModel
{
    _dataModel = dataModel;
    _contentLabel.text = dataModel.skill_title;
    _periodLabel.text = [NSString stringWithFormat:@"第%@期",dataModel.result_num];
    _lotteryLabel.text = dataModel.lottery_name;
    NSString *awardStr = [NSString stringWithFormat:@"%zd",dataModel.prize_amount];
    if(awardStr.length > 8){
        _awardsLabel.text = [NSString stringWithFormat:@"%.02f亿",(CGFloat)dataModel.prize_amount/100000000];
    }else if (awardStr.length > 4){
        _awardsLabel.text = [NSString stringWithFormat:@"%zd万",dataModel.prize_amount/10000];
    }else{
        _awardsLabel.text = [NSString stringWithFormat:@"%zd元", dataModel.prize_amount];
    }
    
}

@end
