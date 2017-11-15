//
//  ACPLoginTextFieldCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPLoginTextFieldCell.h"

@interface ACPLoginTextFieldCell ()

@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation ACPLoginTextFieldCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 14, 14)];
        _iconView.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:_iconView];
        
        _textField = [[DTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame)+10, 0, SCREENWIDTH - 94 , 44)];
        _textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_textField];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_textField.mas_bottom).mas_offset(3);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(0.5);
        }];
        lineView.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    _iconView.image = [UIImage imageNamed:dict[@"image"]];
    _textField.placeholder = dict[@"title"];
    
    if ([dict[@"title"] containsString:@"手机"]) {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if ([dict[@"title"] containsString:@"密码"]) {
        _textField.secureTextEntry = YES;
    }
}

@end
