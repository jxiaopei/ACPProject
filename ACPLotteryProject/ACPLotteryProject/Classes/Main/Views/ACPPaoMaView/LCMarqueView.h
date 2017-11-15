//
//  LCMarqueView.h
//  LotteryClient
//
//  Created by Dick on 2017/7/10.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMarqueView : UIView

@property (nonatomic, strong) NSString *runString;

- (void)startAnimation;

- (void)stopAnimation;

@end
