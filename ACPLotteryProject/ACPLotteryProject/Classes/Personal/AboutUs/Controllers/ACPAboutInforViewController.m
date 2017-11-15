//
//  ACPAboutInforViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPAboutInforViewController.h"

@interface ACPAboutInforViewController ()

@end

@implementation ACPAboutInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    
    UIImageView *iconView = [UIImageView new];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(70);
        make.top.mas_equalTo(100);
    }];
    iconView.image = [UIImage imageNamed:@"AppLogo"];
    iconView.clipsToBounds = YES;
    iconView.layer.cornerRadius = 10;
    
    
    UILabel *versionLab = [UILabel new];
    [self.view addSubview:versionLab];
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(iconView.mas_bottom).mas_offset(10);
    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    versionLab.text = [NSString stringWithFormat:@"v%@",appCurVersion];//@"v1.0";
    versionLab.textColor = [UIColor grayColor];
    versionLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *updateLabel = [UILabel new];
    [self.view addSubview:updateLabel];
    [updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(versionLab.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    updateLabel.text = @"此版本更新点: 全面更新UI界面 增加更多功能 给客户更完美的体验.";
    updateLabel.font = [UIFont systemFontOfSize:14];
    updateLabel.numberOfLines = 0;
    updateLabel.textColor = [UIColor grayColor];
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 50 - 64, SCREENWIDTH, 40)];
    copyrightLabel.backgroundColor = [UIColor clearColor];
    copyrightLabel.font = [UIFont systemFontOfSize:12.0f];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.textColor = [UIColor grayColor];
    copyrightLabel.text = @"Copyright © 2010-2017.\nAll Rights Reserved.";
    copyrightLabel.numberOfLines = 0;
    [self.view addSubview:copyrightLabel];
    
    UILabel *tipInfor1 = [UILabel new];
    [self.view addSubview:tipInfor1];
    [tipInfor1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(copyrightLabel.mas_top).mas_offset(-10);
    }];
    tipInfor1.font = [UIFont systemFontOfSize:13];
    NSString *statusStr = @"官方网址: www.aicaipiao.com";
    NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:statusStr];
    NSRange range = NSMakeRange(5, statusStr.length-5);
    [colorString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range];
    [colorString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
    tipInfor1.attributedText = colorString;
    
    UILabel *tipInfor = [UILabel new];
    [self.view addSubview:tipInfor];
    [tipInfor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(tipInfor1.mas_top).mas_offset(-10);
    }];
    tipInfor.font = [UIFont systemFontOfSize:13];
    NSString *statusStr1 = @"联系电话: 0063-9288100000";
    NSMutableAttributedString *colorString1 = [[NSMutableAttributedString alloc]initWithString:statusStr1];
    NSRange range1 = NSMakeRange(5, statusStr1.length-5);
    [colorString1 addAttribute:NSForegroundColorAttributeName value:GlobalSkyBlueColor range:range1];
    [colorString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
    tipInfor.attributedText = colorString1;
}



@end
