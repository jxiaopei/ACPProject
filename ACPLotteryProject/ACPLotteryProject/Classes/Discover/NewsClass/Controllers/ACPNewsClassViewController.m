//
//  ACPNewsClassViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/6.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPNewsClassViewController.h"
#import "ACPNewsClassTableViewCell.h"
#import "ACPNewsClassDataModel.h"
#import "ACPBaseWebViewController.h"
#import "ACPNewClassDetailViewController.h"

@interface ACPNewsClassViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)NSMutableArray <ACPNewsClassDataModel *> *dataSource;

@end

@implementation ACPNewsClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    [self customBackBtn];
    [self customTitleWith:@"新手讲堂"];
    [self setupTableView];
    [self getData];
}

-(void)getData{
    
    NSLog(@"%@",BaseUrl(NewsClass));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":NewsClass,
                           @"paramData":@{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                                          @"pageSize":@6,
                                          @"type_id" :@1}
                           };
    
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(NewsClass) parameters:dict success:^(id responseObject) {
        
        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                _dataSource = [ACPNewsClassDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data_content"][@"rows"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr = [ACPNewsClassDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data_content"][@"rows"]];
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
    [tableView registerClass:[ACPNewsClassTableViewCell class] forCellReuseIdentifier:@"newsClassCell"];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPNewsClassDataModel *model = _dataSource [indexPath.row];
    ACPNewClassDetailViewController *newClassDetailVC = [ACPNewClassDetailViewController new];
    newClassDetailVC.urlString = model.xy_url_link;
    newClassDetailVC.officialUrlString = model.gf_url_link;
    newClassDetailVC.titleStr = [NSString stringWithFormat:@"%@%@",model.lottery_name,model.type_name];
    [self.navigationController pushViewController:newClassDetailVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ACPNewsClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsClassCell" forIndexPath:indexPath];
    ACPNewsClassDataModel *model = _dataSource [indexPath.row];
    cell.dataModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
