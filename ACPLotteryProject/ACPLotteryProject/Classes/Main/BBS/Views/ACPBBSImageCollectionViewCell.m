//
//  ACPBBSImageCollectionViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBBSImageCollectionViewCell.h"

@implementation ACPBBSImageCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImageView *imageView = [UIImageView new];
        _imageView = imageView ;
        imageView.frame = CGRectMake(0, 0, 70, 70);
        [self addSubview:imageView];
    }
    return self;
}

@end
