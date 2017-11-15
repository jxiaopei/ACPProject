//
//  ACPSecurityHeaderView.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPSecurityHeaderView.h"

@interface ACPSecurityHeaderView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ACPSecurityHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        
        // label
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
//        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.font = [UIFont systemFontOfSize:13];
        self.label = label;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    self.label.text = text;
}




@end
