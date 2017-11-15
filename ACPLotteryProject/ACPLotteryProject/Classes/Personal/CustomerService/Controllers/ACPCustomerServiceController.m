//
//  ACPCustomerServiceController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPCustomerServiceController.h"

@interface ACPCustomerServiceController ()

@end

@implementation ACPCustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:@"客服"];
}

-(void)viewWillAppear:(BOOL)animated{
    //    [super viewWillAppear:animated];
    NSString *url = (NSString *)[[YYCache cacheWithName:CacheKey] objectForKey:@"serviceUrl"];
    self.urlString = [url isNotNil]?url : @"";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

@end
