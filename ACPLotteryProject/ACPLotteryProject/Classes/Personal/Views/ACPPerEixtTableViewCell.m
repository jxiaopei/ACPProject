//
//  ACPPerEixtTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPPerEixtTableViewCell.h"

@interface ACPPerEixtTableViewCell ()

@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIView *topView;

@end

@implementation ACPPerEixtTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GlobalLightGreyColor;
        UIButton *exitBtn = [UIButton new];
        _loginBtn = exitBtn;
        [self addSubview:exitBtn];
        [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.centerY.mas_equalTo(0);
        }];
        exitBtn.backgroundColor = [UIColor whiteColor];
        exitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [exitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(didClickExitBtn:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIView *topLineView = [UIView new];
//        [exitBtn addSubview:topLineView];
//        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0.5);
//            make.left.right.mas_equalTo(0);
//            make.top.mas_equalTo(0);
//        }];
//        topLineView.backgroundColor = [UIColor grayColor];
//        topLineView.alpha = 0.8;
//        _topView = topLineView;
//        
//        UIView *lineView = [UIView new];
//        [exitBtn addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0.5);
//            make.left.right.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
//        }];
//        lineView.backgroundColor = [UIColor grayColor];
//        lineView.alpha = 0.8;
//        _lineView = lineView;
        
    }
    return self;
}

-(void)setIshiddenBtn:(BOOL)ishiddenBtn{
    _ishiddenBtn = ishiddenBtn;
//    _lineView.hidden = ishiddenBtn;
//    _topView.hidden = ishiddenBtn;
    _loginBtn.hidden = ishiddenBtn;
}

-(void)didClickExitBtn:(UIButton *)sender{
    self.didClickExitBtnBlock();
}
@end
