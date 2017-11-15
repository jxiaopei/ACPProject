//
//  ACPBBSListDataModel.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBBSListDataModel.h"

@implementation ACPBBSListDataModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"Id" : @"id"};
}

-(CGFloat)rowHeight
{
    CGSize textSize = [self.release_content boundingRectWithSize:CGSizeMake(SCREENWIDTH - 20, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    CGFloat textHeight = textSize.height > 60 ? 60 : textSize.height;
    CGFloat collectionViewHeight = 0;
    NSArray *imageArr = nil;
    if(self.release_image_url.length >0){
        imageArr = [self.release_image_url componentsSeparatedByString:@","];
        if(imageArr.count){
            NSUInteger row = imageArr.count % 3 ?imageArr.count / 3 + 1 : imageArr.count / 3;
            collectionViewHeight = row * 72;
        }
    }
    if(_community_top){
          return 145;
    }
    return textHeight + collectionViewHeight + 115;
}

@end
