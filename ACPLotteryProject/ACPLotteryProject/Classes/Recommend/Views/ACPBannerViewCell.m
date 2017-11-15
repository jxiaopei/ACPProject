//
//  ACPBannerViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/11.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBannerViewCell.h"

@implementation ACPBannerViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [UIImageView new];
        [self addSubview:self.imageView];
        self.imageView.frame = CGRectMake(0, 0, SCREENWIDTH, self.bounds.size.height);
    }
    
    return self;
    
}

@end
