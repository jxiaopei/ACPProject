//
//  ACPTextFieldCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/1.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPTextFieldCell.h"

@interface ACPTextFieldCell()

@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation ACPTextFieldCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.frame = CGRectMake(10, 10, 60, 30);
        _titleLabel.font = [UIFont systemFontOfSize:13];
        
        _textField = [[DTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, 10, SCREENWIDTH - 80, 30)];
        _textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_textField];
        
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

-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
    _textField.placeholder = [NSString stringWithFormat:@"请输入您的%@",title];
}

@end
