//
//  ACPConcernedTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPConcernedTableViewCell.h"

@interface ACPConcernedTableViewCell ()

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *fansLabel;
@property(nonatomic,strong)UIButton *attentionBtn;
@property(nonatomic,strong)UILabel *introductionLabel;

@end

@implementation ACPConcernedTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        _iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.height.width.mas_equalTo(60);
        }];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 30;
        
        UILabel *nameLabel = [UILabel new];
        [self addSubview:nameLabel];
        _nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconView.mas_top);
            make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
            make.right.mas_equalTo(-75);
        }];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        
        UILabel *introductionLabel = [UILabel new];
        [self addSubview:introductionLabel];
        _introductionLabel = introductionLabel;
        [introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
            make.right.mas_equalTo(-75);
        }];
        introductionLabel.textColor = [UIColor grayColor];
        introductionLabel.font = [UIFont systemFontOfSize:13];
        introductionLabel.adjustsFontSizeToFitWidth = YES;
        
        UILabel *fansLabel = [UILabel new];
        [self addSubview:fansLabel];
        _fansLabel = fansLabel;
        [fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(introductionLabel.mas_bottom).mas_offset(5);
           make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
            make.right.mas_equalTo(-75);
        }];
        fansLabel.textColor = [UIColor grayColor];
        fansLabel.text = @"粉丝 0  发言 0";
        fansLabel.font = [UIFont systemFontOfSize:13];
        fansLabel.adjustsFontSizeToFitWidth = YES;
        
        UIButton *attentionBtn = [UIButton new];
        [self addSubview:attentionBtn];
        _attentionBtn = attentionBtn;
        [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        [attentionBtn setImage:[UIImage imageNamed:@"添加关注"] forState:UIControlStateNormal];
        [attentionBtn setImage:[UIImage imageNamed:@"取消关注"] forState:UIControlStateSelected];
        [attentionBtn addTarget:self action:@selector(didClickAttentionBtn:) forControlEvents:UIControlEventTouchUpInside];
        
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

-(void)setDataModel:(ACPConcernedDataModel *)dataModel{
    _dataModel = dataModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(dataModel.user_image_url)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _nameLabel.text = dataModel.user_name;
    _introductionLabel.text = dataModel.user_brief_introduction ? dataModel.user_brief_introduction : @"暂无简介";
    _fansLabel.text = [NSString stringWithFormat:@"粉丝 %@  发言 %@",dataModel.count_fans,dataModel.count_community];
    _attentionBtn.selected = YES;
}

-(void)setFansDataModel:(ACPConcernedDataModel *)fansDataModel{
    _fansDataModel = fansDataModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(fansDataModel.user_image_url)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _nameLabel.text = fansDataModel.user_name;
    _introductionLabel.text = fansDataModel.user_brief_introduction ? fansDataModel.user_brief_introduction : @"暂无简介";
    _fansLabel.text = [NSString stringWithFormat:@"粉丝 %@  发言 %@",fansDataModel.count_fans,fansDataModel.count_community];
    _attentionBtn.selected = fansDataModel.user_concerned;
//    _attentionBtn.hidden = YES;
    
}

-(void)setRecommendDataModel:(ACPRecommendConDataModel *)recommendDataModel{
    _recommendDataModel = recommendDataModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(recommendDataModel.user_image_url)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _nameLabel.text = recommendDataModel.user_name;
    _introductionLabel.text = recommendDataModel.user_brief_introduction ? recommendDataModel.user_brief_introduction : @"暂无简介";
    _fansLabel.text = [NSString stringWithFormat:@"粉丝 %@  发言 %@",recommendDataModel.count_fans,recommendDataModel.count_community];
    _attentionBtn.selected = NO;
}

-(void)didClickAttentionBtn:(UIButton *)sender{
    if(self.didClickAttentionActionBtnBlock){
        self.didClickAttentionActionBtnBlock(sender);
    }
}

@end
