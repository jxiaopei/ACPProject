//
//  ACPActionViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPActionViewController.h"
#import "ACPActionDataModel.h"
#import "ACPActionTableViewCell.h"
#import "ACPActionCollectionViewCell.h"
#import "ACPBaseWebViewController.h"

@interface ACPActionViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *actionCollectionView;
@property(nonatomic,strong)NSMutableArray <ACPActionDataModel *>*dataSource;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageNum;

@end

@implementation ACPActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    [self customTitleWith:@"活动"];
    [self customBackBtn];
    [self setupTableView];
    [self getData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(ActionsList));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":ActionsList,
                           @"paramData":@{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                                          @"pageSize":@6,}
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(ActionsList) parameters:dict success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"]){
            
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                self.dataSource = [ACPActionDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"activityList"][@"rows"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =  [ACPActionDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"activityList"][@"rows"]];
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
    [tableView registerClass:[ACPActionTableViewCell class] forCellReuseIdentifier:@"actionCell"];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    tableView.tableHeaderView = [self setupHeader];
    
}

-(UIView *)setupHeader{
    
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREENWIDTH, 120);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH, 120);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *actionCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120) collectionViewLayout:layout];
    [header addSubview:actionCollectionView];
    _actionCollectionView = actionCollectionView;
    actionCollectionView.delegate = self;
    actionCollectionView.dataSource = self;
    [actionCollectionView registerClass:[ACPActionCollectionViewCell class] forCellWithReuseIdentifier:@"actionAdvCell"];
    
    return header;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath ];
    cell.dataModel = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPBaseWebViewController *actionDetailVC = [ACPBaseWebViewController new];
    ACPActionDataModel *model = _dataSource[indexPath.row];
    actionDetailVC.title = model.act_name;
    actionDetailVC.urlString = model.act_link_url;
    [self.navigationController pushViewController:actionDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    BPBaseWebViewController *actionDetailVC = [BPBaseWebViewController new];
    //    XPBActionDataModel *model = _dataSource[indexPath.row];
    //    actionDetailVC.title = model.act_name;
    //    actionDetailVC.urlString = model.act_link_url;
    //    [self.navigationController pushViewController:actionDetailVC animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACPActionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"actionAdvCell" forIndexPath:indexPath];
    //    cell.dataModel = self.dataSource[indexPath.row];
    cell.iconView.image = [UIImage imageNamed:@"活动图"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 120);
}

-(NSMutableArray<ACPActionDataModel *>*)dataSource{
    if(_dataSource == nil){
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}



@end
