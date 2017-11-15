//
//  ACPNewsClassTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/6.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPNewsClassTableViewCell.h"

@interface ACPNewsClassTableViewCell()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *iconView;

@end

@implementation ACPNewsClassTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        _iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(100);
        }];
        
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

-(void)setDataModel:(ACPNewsClassDataModel *)dataModel{
    _dataModel = dataModel;
    _titleLabel.text = dataModel.skill_title;
    [_iconView  sd_setImageWithURL:[NSURL URLWithString:dataModel.picture_link] placeholderImage:[UIImage imageNamed:@"占位图"]];
    
}

@end
