//
//  ACPSecurityCenterController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPSecurityCenterController.h"
#import "ACPSecurityTableViewCell.h"
#import "ACPSecurityHeaderView.h"
#import "ACPIDBindingViewController.h"
#import "ACPPhoneBindingController.h"
#import "ACPModifyPasswordController.h"
#import "ACPBankCardViewController.h"
#import "ACPPayPasswordController.h"

@interface ACPSecurityCenterController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *detailArr;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ACPSecurityCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:@"安全中心"];
    _titleArr = @[@[@"身份绑定",@"修改密码"],@[@"银行卡",@"支付密码"]];//@"手机绑定",
    _detailArr = @[@[@"领奖,提款的重要依据",@"用户信息,登录以及中奖提醒",@"为了您的账户安全,建议您定期修改密码"],@[@"绑定银行卡,以便取款",@"资金变动时需要验证"]];
    [self setupTableView];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[ACPSecurityTableViewCell class] forCellReuseIdentifier:@"securityCenterCell"];
    [tableView registerClass:[ACPSecurityHeaderView class] forHeaderFooterViewReuseIdentifier:@"securityHeader"];
    tableView.tableFooterView = [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            ACPIDBindingViewController *idBindingVC = [ACPIDBindingViewController new];
            [self.navigationController pushViewController:idBindingVC animated:YES];
//        }else if (indexPath.row == 1){
//            ACPPhoneBindingController *phoneBindingVC = [ACPPhoneBindingController new];
//            [self.navigationController pushViewController:phoneBindingVC animated:YES];
        }else if (indexPath.row == 1){
            ACPModifyPasswordController *modifyPwVC = [ACPModifyPasswordController new];
            [self.navigationController pushViewController:modifyPwVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            ACPBankCardViewController *bankCardVC = [ACPBankCardViewController new];
            [self.navigationController pushViewController:bankCardVC animated:YES];
        }else if (indexPath.row == 1){
            ACPPayPasswordController *payPwVC = [ACPPayPasswordController new];
            [self.navigationController pushViewController:payPwVC animated:YES];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *titleArr = _titleArr[section];
    return titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPSecurityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"securityCenterCell" forIndexPath:indexPath];
    NSArray *titleArr = _titleArr[indexPath.section];
    NSArray *detailArr = _detailArr[indexPath.section];
    if(indexPath.section == 0 ){ //&& (indexPath.row == 0 || indexPath.row == 1)
//        NSString *statusStr = titleArr[indexPath.row];
//        NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:statusStr];
//        NSRange range = NSMakeRange(4, statusStr.length-4);
//        [colorString addAttribute:NSForegroundColorAttributeName value:GlobalSkyBlueColor range:range];
//        [colorString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
//        cell.titleLabel.attributedText = colorString;
//    }else{
        cell.titleLabel.text = titleArr[indexPath.row];
    }
    cell.detailLabel.text = detailArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ACPSecurityHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"securityHeader"];

    if (section == 0 ) {
        header.text = @"账户保护";
    } else {
        header.text = @"资金保护";
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}


@end
