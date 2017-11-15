//
//  LCIntroView.h
//  LotteryClient
//
//  Created by Dick on 2017/7/24.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCIntroView : UIView

+ (instancetype)showInView:(UIView *)superView;

@property (nonatomic, strong) NSArray *images;

@end
