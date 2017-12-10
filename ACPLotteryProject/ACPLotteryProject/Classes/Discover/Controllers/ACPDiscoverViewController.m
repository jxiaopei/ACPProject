//
//  ACPDiscoverViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPDiscoverViewController.h"
#import "ACPPersonalTableViewCell.h"
#import "ACPNewsClassViewController.h"
#import "ACPActionViewController.h"
#import "ACPAwardsViewController.h"
#import "ACPLotteryViewController.h"

@interface ACPDiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation ACPDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTitleWith:@"发现"];
    [self setupTableView];
    _dataArr = @[@[@{@"title": @"新手讲堂",@"detail":@"竞猜玩法\"养成记\""},],@[@{@"title": @"活动推荐",@"detail":@"精彩活动,回馈新老客户"},@{@"title": @"大奖专栏",@"detail":@"沾沾喜气,中百万大奖"}],@[@{@"title": @"直播",@"detail":@"每晚08:00准时开播"},@{@"title": @"游戏推荐",@"detail":@"寻找更多游戏,赢更多大奖"}],];//@{@"title": @"专家推荐",@"detail":@"跟大神,中大奖"}//@[@{@"title": @"积分商城",@"detail":@"赢积分,换豪礼!"},@{@"title": @"分享赢好礼",@"detail":@""}]
}
- (void)setupTableView
{
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
    }];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 50;
    tableView.estimatedSectionHeaderHeight = 10;
    [tableView registerClass:[ACPPersonalTableViewCell class] forCellReuseIdentifier:@"discoverCell"];
    tableView.tableFooterView = [UIView new];
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            ACPNewsClassViewController *newsClassVC = [ACPNewsClassViewController new];
            [self.navigationController pushViewController:newsClassVC animated:YES];
//        }else if (indexPath.row == 1){
            
        }
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            ACPActionViewController *actionVC = [ACPActionViewController new];
            [self.navigationController pushViewController:actionVC animated:YES];
        }else if (indexPath.row == 1){
            ACPAwardsViewController *awardsVC = [ACPAwardsViewController new];
            [self.navigationController pushViewController:awardsVC animated:YES];
        }
    }else if (indexPath.section == 2){
        if(indexPath.row == 0){
            ACPLotteryViewController *lotteryVC  = [[ACPLotteryViewController alloc] init];
            [self.navigationController pushViewController:lotteryVC animated:YES];
        }else if (indexPath.row == 1){
            [self.tabBarController setSelectedIndex:1];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *titleArr = _dataArr[section];
    return titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArr = _dataArr[indexPath.section];
    ACPPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoverCell" forIndexPath:indexPath];
    cell.titleLabel.text = titleArr[indexPath.row][@"title"];
    cell.detailLabel.text = titleArr[indexPath.row][@"detail"];
    cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"discover_%zd",indexPath.section * 2 + indexPath.row + 1]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
