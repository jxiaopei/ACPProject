//
//  ACPIntergralServiceCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPIntergralServiceCell.h"

@implementation ACPIntergralServiceCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.iconView = [UIImageView new];
        [self addSubview:self.iconView];
        self.iconView.frame = CGRectMake((SCREENWIDTH/3 - 30)/2, 5, 30, 30);
        
        self.title = [UILabel new];
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        self.title.frame = CGRectMake(5, 60, SCREENWIDTH /3 -10, 20);
    }
    
    return self;
    
}

@end
