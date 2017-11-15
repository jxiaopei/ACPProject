//
//  ACPMainPageLotteryCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPMainPageLotteryCell.h"

@implementation ACPMainPageLotteryCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.iconView = [UIImageView new];
        [self addSubview:self.iconView];
        self.iconView.frame = CGRectMake(((SCREENWIDTH -2*2)/3 - 50)/2, 5, 50, 50);
        
        self.title = [UILabel new];
        self.title.textColor = [UIColor blackColor];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        self.title.frame = CGRectMake(0, 60, (SCREENWIDTH -2*2)/3, 20);
    }
    
    return self;
    
}

@end
