//
//  ACPPhoneCodeCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/1.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPPhoneCodeCell.h"

@interface ACPPhoneCodeCell()

@property(nonatomic,strong)UILabel *titleLabel;


@end

@implementation ACPPhoneCodeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.frame = CGRectMake(10, 10, 60, 30);
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"验证码";
        
        _requstBtn = [UIButton new];
        [self.contentView addSubview:_requstBtn];
        _requstBtn.frame = CGRectMake(SCREENWIDTH - 60 - 10, 10, 70, 30);
        [_requstBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_requstBtn setTitleColor:GlobalRedColor forState:UIControlStateNormal];
        [_requstBtn addTarget:self action:@selector(didClickRequstCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        _requstBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        _textField = [[DTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, 10, SCREENWIDTH - 80 -70, 30)];
        _textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_textField];
        _textField.placeholder = @"请输入4-6位短信验证码";
        
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

-(void)didClickRequstCodeBtn:(UIButton *)sender{
    _requstBtn.enabled = NO;
    if(self.didClickRequstBtnBlock){
        self.didClickRequstBtnBlock();
    }
}




@end
