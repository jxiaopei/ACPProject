//
//  ACPIntegralDetailTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPIntegralDetailTableViewCell.h"

@interface ACPIntegralDetailTableViewCell ()

@property(nonatomic,strong)UILabel *missionLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *integralLabel;

@end

@implementation ACPIntegralDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *missonLabel = [UILabel new];
        [self addSubview:missonLabel];
        _missionLabel = missonLabel;
        [missonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
        missonLabel.font = [UIFont systemFontOfSize:13];
        missonLabel.text = @"任务内容";
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.text = @"时间日期";
        dateLabel.textColor = [UIColor grayColor];
        
        UILabel *integralLabel = [UILabel new];
        [self addSubview:integralLabel];
        _integralLabel = integralLabel;
        [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        integralLabel.font = [UIFont systemFontOfSize:15];
        integralLabel.text = @"积分数额";
        
    }
    
    return self;
    
}

-(void)setDataModel:(ACPIntegralDetailModel *)dataModel
{
    _dataModel = dataModel;
    _missionLabel.text = dataModel.mission_name;
    _dateLabel.text = dataModel.create_time;
    _integralLabel.text = dataModel.mission_point;
    
}

@end
