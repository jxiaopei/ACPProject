//
//  ACPBaseWebViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBaseWebViewController.h"

@interface ACPBaseWebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIView *errorView;

@end

@implementation ACPBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadrequst];
    if([_titleStr isNotNil]){
      [self customTitleWith:_titleStr];  
    }
    
}

-(void)setupWebView
{
    self.webView = [UIWebView new];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.mas_equalTo(0);
    }];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = YES;
    
    
}

-(void)loadrequst{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //    NSURL *URL = request.URL;
    //    NSString *scheme = [URL scheme];
    
    return YES;
}


//-(void)webViewDidStartLoad:(UIWebView *)webView{
////    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
//}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    for(int i = 0;i < self.webView.subviews.count;i++){
        if(self.webView.subviews[i].tag == 1000){
            UIView *view = self.webView.subviews[i];
            [view removeFromSuperview];
        }
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    UIView *errorView = [UIView new];
    [self.webView addSubview:errorView];
    errorView.frame = self.webView.bounds;
    errorView.backgroundColor = GlobalLightGreyColor;
    errorView.tag = 1000;
    _errorView = errorView;
    
    UIImageView *imageView = [UIImageView new];
    [errorView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(120);
        make.width.height.mas_equalTo(100);
    }];
    imageView.image = [UIImage imageNamed:@"页面错误"];
    
    UILabel *tipLabel = [UILabel new];
    [errorView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(10);
    }];
    tipLabel.font = [UIFont systemFontOfSize:18];
    tipLabel.text = @"页面失联了";
    
    UILabel *statusLabel = [UILabel new];
    [errorView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(5);
    }];
    statusLabel.text = @"攻城狮正在搜索中...";
    statusLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton * reloadBtn = [UIButton new];
    [errorView addSubview: reloadBtn];
    [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(statusLabel.mas_bottom).mas_offset(60);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    reloadBtn.layer.masksToBounds = YES;
    reloadBtn.layer.cornerRadius = 5;
    [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reloadBtn.backgroundColor = [UIColor whiteColor];
    reloadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [reloadBtn addTarget:self action:@selector(didClickReloadBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didClickReloadBtn:(UIButton *)sender{
    
    for(int i = 0;i < self.webView.subviews.count;i++){
        if(self.webView.subviews[i].tag == 1000){
            UIView *view = self.webView.subviews[i];
            [view removeFromSuperview];
        }
    }
    [self loadrequst];
}


@end
