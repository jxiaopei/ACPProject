//
//  CommentManager.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/11/8.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^commentComplateBlock)(UITextView *textView,UIView *markView);

@interface CommentManager : NSObject

+(instancetype)shareManager;

-(void)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder commentComplateBlock:(commentComplateBlock)complateBlock doNothingBlock:(void(^)())noThingBlock;

@end
