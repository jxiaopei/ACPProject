//
//  ACPLotteryDataCollectionViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPLotteryDataCollectionViewCell.h"

@implementation ACPLotteryDataCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImageView *imageView = [UIImageView new];
        _imageView = imageView ;
        imageView.frame = CGRectMake(0, 0, (SCREENWIDTH - 85)/10, (SCREENWIDTH - 85)/10);
        [self addSubview:imageView];
        
        UILabel *titleLabel = [UILabel new];
        _titleLabel = titleLabel;
        titleLabel.frame = CGRectMake(0, 0, (SCREENWIDTH - 85)/10, (SCREENWIDTH - 85)/10);
        [self addSubview:titleLabel];
        titleLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size: 14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return self;
}

@end
