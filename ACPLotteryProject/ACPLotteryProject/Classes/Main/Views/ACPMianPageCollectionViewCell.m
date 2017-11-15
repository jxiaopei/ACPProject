//
//  ACPMianPageCollectionViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPMianPageCollectionViewCell.h"

@implementation ACPMianPageCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.iconView = [UIImageView new];
        [self addSubview:self.iconView];
        self.iconView.frame = CGRectMake(((SCREENWIDTH -2*2)/5 - 44)/2, 5, 44, 44);
        
        self.title = [UILabel new];
        self.title.textColor = [UIColor blackColor];
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        self.title.frame = CGRectMake(0, 60, (SCREENWIDTH -2*2)/5, 20);
        
        self.detailText = [UILabel new];
        self.detailText.textColor = [UIColor grayColor];
        self.detailText.font = [UIFont systemFontOfSize:12];
        self.detailText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.detailText];
        self.detailText.frame = CGRectMake(0, 85, (SCREENWIDTH -2*2)/5, 20);
        
    }
    
    return self;
    
}

@end
