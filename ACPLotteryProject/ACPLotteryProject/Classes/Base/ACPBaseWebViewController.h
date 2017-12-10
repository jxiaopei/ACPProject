//
//  ACPBaseWebViewController.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBaseViewController.h"

@interface ACPBaseWebViewController : UIViewController

@property(nonatomic,copy)NSString *urlString;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,strong)UIWebView *webView;
- (void)customTitleWith:(NSString *)title;
- (void)customBackBtn;

@end
