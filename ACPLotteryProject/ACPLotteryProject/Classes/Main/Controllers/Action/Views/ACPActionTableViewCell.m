//
//  ACPActionTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPActionTableViewCell.h"

@interface ACPActionTableViewCell()

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIButton *statueBtn;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;

@end

@implementation ACPActionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        _iconView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(60);
            make.left.mas_equalTo(10);
        }];
        imageView.image = [UIImage imageNamed:@"占位图"];
        
        UILabel *nameLabel = [UILabel new];
        [self addSubview:nameLabel];
        _nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).mas_offset(5);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        nameLabel.text = @"活动名称";
        nameLabel.textColor = GlobalRedColor;
        nameLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *contentLabel = [UILabel new];
        [self addSubview:contentLabel];
        _contentLabel = contentLabel;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(10);
            
        }];
        contentLabel.text = @"活动内容";
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        //        contentLabel.numberOfLines = 3;
        
        UIButton *statueBtn = [UIButton new];
        [self addSubview:statueBtn];
        _statueBtn =  statueBtn;
        [statueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.centerY.mas_equalTo(nameLabel);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(50);
        }];
        statueBtn.layer.masksToBounds = YES;
        statueBtn.layer.cornerRadius = 5;
        statueBtn.layer.borderColor = [UIColor blackColor].CGColor;
        statueBtn.layer.borderWidth = 1;
        [statueBtn setTitle:@"活动状态" forState:UIControlStateNormal];
        [statueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        statueBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        //        statueBtn.backgroundColor = [UIColor grayColor];
        
        UILabel *timeLabel = [UILabel new];
        [self addSubview:timeLabel];
        _timeLabel = timeLabel;
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(5);
        }];
        timeLabel.text = @"活动时间:xxxx年xx月xx-xx月xx日";
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.adjustsFontSizeToFitWidth = YES;
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        lineView.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

-(void)setDataModel:(ACPActionDataModel *)dataModel{
    
    _dataModel = dataModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:dataModel.act_pic_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
    NSArray *typeNameArr = @[@"未开始",@"进行中",@"已结束",@"已作废"];
    [_statueBtn setTitle:typeNameArr[dataModel.act_type - 1] forState:UIControlStateNormal];
    
    _nameLabel.text = dataModel.act_name;
    NSString *beginStr = [dataModel.begin_time insertStandardTimeFormat];
    NSString *endStr = [dataModel.end_time insertStandardTimeFormat];
    NSString *beginYear = [beginStr substringToIndex:4];
    NSString *endYear = [endStr substringToIndex:4];
    if([endYear isEqualToString:beginYear]){
        endStr = [endStr substringFromIndex:5];
    }
    beginStr = [beginStr substringToIndex:beginStr.length - 3];
    endStr = [endStr substringToIndex:endStr.length - 3];
    _timeLabel.text = [NSString stringWithFormat:@"%@至 %@",beginStr,endStr];
    _contentLabel.text = dataModel.act_content;
}

@end
