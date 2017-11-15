//
//  LCTextFieldCell.m
//  LotteryClient
//
//  Created by Dick on 2017/7/3.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "LCTextFieldCell.h"

@interface LCTextFieldCell ()

@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation LCTextFieldCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 14, 14)];
        _iconView.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:_iconView];
        
        _textField = [[DTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame)+10, 0, SCREENWIDTH - 54, 44)];
        _textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_textField];
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
