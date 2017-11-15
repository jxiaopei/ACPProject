//
//  ACPSignInCollectionViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPSignInCollectionViewCell.h"

@implementation ACPSignInCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIButton *btn = [UIButton new];
        _btn = btn;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(15);
            make.width.height.mas_equalTo(25);
        }];
        
        //        [btn setBackgroundImage:[UIImage imageNamed:@"未签到"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"签到成功"] forState:UIControlStateSelected];
        [btn setTitle:@"0" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        UIView *horView = [UIView new];
        [self addSubview:horView];
        [horView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
        horView.backgroundColor = GlobalLightGreyColor;
        
    }
    return self;
}

@end
