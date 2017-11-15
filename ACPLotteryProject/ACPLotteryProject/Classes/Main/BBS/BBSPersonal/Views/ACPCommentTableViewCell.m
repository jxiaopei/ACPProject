//
//  ACPCommentTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPCommentTableViewCell.h"

@interface ACPCommentTableViewCell ()

@property(nonatomic,strong)UILabel *anthorLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UIImageView *iconView;

@end

@implementation ACPCommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        _iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(15);
            make.width.height.mas_equalTo(40);
        }];
        iconView.image = [UIImage imageNamed:@"默认头像"];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 20;
        iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickHeaderView:)];
        [iconView addGestureRecognizer:tap];
        
        UILabel *anthorLabel = [UILabel new];
        [self addSubview:anthorLabel];
        [anthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconView.mas_top);
            make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
        }];
        _anthorLabel = anthorLabel;
        anthorLabel.font = [UIFont systemFontOfSize:13];
        anthorLabel.textColor = [UIColor grayColor];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
            make.bottom.mas_equalTo(iconView.mas_bottom);
        }];
        _dateLabel = dateLabel;
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textColor = [UIColor grayColor];
        
        UILabel *levelLabel = [UILabel new];
        [self addSubview:levelLabel];
        _levelLabel = levelLabel;
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(iconView.mas_top);
        }];
        levelLabel.textColor = [UIColor grayColor];
        levelLabel.font = [UIFont systemFontOfSize:13];
        
        UILabel *contentLabel = [UILabel new];
        [self addSubview:contentLabel];
        _contentLabel = contentLabel;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
        }];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
        lineView.backgroundColor = GlobalLightGreyColor;
        
    }
    return self;
}

-(void)didClickHeaderView:(UITapGestureRecognizer *)tap{
    if(self.didClickHeaderViewBlock){
        self.didClickHeaderViewBlock();
    }
}

-(void)setDataModel:(ACPCommentDataModel *)dataModel
{
    _dataModel = dataModel;
    self.anthorLabel.text = dataModel.user_name;
    self.contentLabel.text = dataModel.return_content;
    self.dateLabel.text = [dataModel.return_time insertStandardTimeFormat];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(dataModel.user_image_url)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
}

@end
