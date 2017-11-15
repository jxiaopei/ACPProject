//
//  ACPLotteryHistroyViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/18.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPLotteryHistroyViewController.h"
#import "ACPLotteryListModel.h"
#import "ACPLotteryListTableViewCell.h"

@interface ACPLotteryHistroyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <ACPLotteryListModel *>*dataSource;

@end

@implementation ACPLotteryHistroyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:_titleStr];
    _pageNum = 1;
    [self getData];
    [self setupTableView];
    
}

-(void)getData{
    NSLog(@"%@",BaseUrl(LotteryHistroy));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":LotteryHistroy,
                           @"paramData":@{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                                          @"pageSize":@6,
                                          @"lottery_type" :_typeId}
                           };
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(LotteryHistroy) parameters:dict success:^(id responseObject) {
        
        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                _dataSource = [ACPLotteryListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lottery_list"][@"rows"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr = [ACPLotteryListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lottery_list"][@"rows"]];
                if(!mutableArr.count)
                {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                    [self.dataSource addObjectsFromArray:mutableArr];
                }
            }
            [_tableView reloadData];
        }else{
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } fail:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];

}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 64);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ACPLotteryListTableViewCell class] forCellReuseIdentifier:@"lotteryHistroyCell"];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 150;
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self getData];
    }];
    tableView.mj_header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        _pageNum++;
        
        [self getData];
    }];
    tableView.mj_footer = footer;
    
    tableView.tableFooterView = [UIView new];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPLotteryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lotteryHistroyCell" forIndexPath:indexPath];
    ACPLotteryListModel *dataModel = self.dataSource[indexPath.row];
    cell.dataModel = dataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACPLotteryListModel *dataModel = self.dataSource[indexPath.row];
    return dataModel.rowHeight;
}



@end
