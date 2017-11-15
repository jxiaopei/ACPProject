//
//  ACPMegCenterViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/1.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPMegCenterViewController.h"
#import "ACPMsgSwitchTableViewCell.h"
#import "ACPMsgSwitchDetailTableViewCell.h"

@interface ACPMegCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)UITableView *tableView;


@end

@implementation ACPMegCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:@"新消息通知"];
    _titleArr = @[@"推送开关",@"每日签到提醒",@"积分公告",@"热点消息",@"通知反馈",@"免打扰时间"];
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
    [tableView registerClass:[ACPMsgSwitchTableViewCell class] forCellReuseIdentifier:@"msgSwitchCell"];
    [tableView registerClass:[ACPMsgSwitchDetailTableViewCell class] forCellReuseIdentifier:@"msgSwitchDetailCell"];
    tableView.rowHeight = 50;
    tableView.tableFooterView = [UIView new];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == _titleArr.count - 1){
        ACPMsgSwitchDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgSwitchDetailCell" forIndexPath:indexPath];
        cell.detailLabel.text = @"晚23点到次日8点不推送消息";
        cell.titleLabel.text = _titleArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ACPMsgSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgSwitchCell" forIndexPath:indexPath];
        cell.titleLabel.text = _titleArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}



@end
