//
//  ACPBBSDetailDataModel.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBBSDetailDataModel.h"

@implementation ACPBBSDetailDataModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"return_message_list":[ACPCommentDataModel class]};
}

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
    if(self.release_image_url.length >0){
        NSArray *imageArr = [self.release_image_url componentsSeparatedByString:@","];
        if(imageArr.count){
            NSUInteger row = imageArr.count % 3 ?imageArr.count / 3 + 1 : imageArr.count / 3;
            collectionViewHeight = row * 72;
        }
    }
    return textHeight + collectionViewHeight + 135;
}

@end
