//
//  ACPGeneralViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/1.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPGeneralViewController.h"
#import "ACPGeneralTableViewCell.h"
#import "ACPCleanCacheManager.h"
#import "ACPMegCenterViewController.h"
#import "ACPBaseNetworkServiceTool.h"

@interface ACPGeneralViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ACPGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self customBackBtn];
    [self customTitleWith:@"通用"];
    _titleArr = @[@"新版本检测",@"清理缓存"];//新消息通知
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
    [tableView registerClass:[ACPGeneralTableViewCell class] forCellReuseIdentifier:@"generalCell"];
    tableView.tableFooterView = [UIView new];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
//        ACPMegCenterViewController *msgVC = [ACPMegCenterViewController new];
//        [self.navigationController pushViewController:msgVC animated:YES];
        [[ACPBaseNetworkServiceTool shareServiceTool] getUpdateInforWithCallBack:^{
            [MBProgressHUD showSuccess:@"已是最新版本"];
        }];
        
    }else if (indexPath.row == 1){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"确定要清理缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CGFloat cacheSize = [ACPCleanCacheManager folderSizeAtPath];
            NSString *baseURL = BaseHttpUrl;
            [ACPCleanCacheManager cleanCache:^{
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"成功清理%.2fM缓存空间",cacheSize]];
                [[YYCache cacheWithName:CacheKey] setObject:baseURL forKey: @"serviceHost"];
                [tableView reloadData];
            }];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:commitAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generalCell" forIndexPath:indexPath];
    cell.titleLabel.text = _titleArr[indexPath.row];
    if(indexPath.row == 1){
        cell.detailLabel.text = [NSString stringWithFormat:@"%.2fM",[ACPCleanCacheManager folderSizeAtPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

@end
