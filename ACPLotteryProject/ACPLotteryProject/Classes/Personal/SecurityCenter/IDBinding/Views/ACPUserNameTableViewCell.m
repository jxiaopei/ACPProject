//
//  ACPUserNameTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/1.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPUserNameTableViewCell.h"

@interface ACPUserNameTableViewCell()

@property(nonatomic,strong)UILabel *usernameLabel;

@end

@implementation ACPUserNameTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [UILabel new];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"用户名";
        
        _usernameLabel = [UILabel new];
        [self.contentView addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_offset(10);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(SCREENWIDTH - 90);
            make.height.mas_equalTo(30);
        }];
        _usernameLabel.font = [UIFont systemFontOfSize:13];
        _usernameLabel.text = @"用户名称";
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(5);
            make.bottom.mas_equalTo(0);
        }];
        lineView.backgroundColor = GlobalLightGreyColor;
        
    }
    return self;
}

-(void)setUsername:(NSString *)username{
    _username = username;
    _usernameLabel.text = username;
}

@end
