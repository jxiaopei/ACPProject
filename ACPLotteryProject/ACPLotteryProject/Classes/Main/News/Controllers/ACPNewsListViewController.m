//
//  ACPNewsListViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPNewsListViewController.h"
#import "ACPNewsTitleDataModel.h"
#import "ACPNewsListDataModel.h"
#import "ACPNewsListTableViewCell.h"
#import "ACPNewsDetailViewController.h"
#import <SDCycleScrollView.h>

@interface ACPNewsListViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property(nonatomic,strong)NSArray <ACPNewsTitleDataModel *>*titleArr;
@property(nonatomic,copy)void(^didTitleViewGetDataBlock)(NSArray <ACPNewsTitleDataModel *>*titleArr);
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)NSMutableArray <ACPNewsListDataModel *>*dataSource;
@property(nonatomic,strong)SDCycleScrollView *bannerView;

@end

@implementation ACPNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    _selectedBtn = [UIButton new];
    _selectedBtn.tag = 101;
    [self customTitleWith:@"资讯"];
    [self customBackBtn];
    [self setupTItleView];
    [self setupTableView];
    [self getTitleData];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.frame = CGRectMake(0, 50, SCREENWIDTH, SCREENHEIGHT- 64 - 50);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ACPNewsListTableViewCell class] forCellReuseIdentifier:@"newsListCell"];
    _tableView = tableView;
    tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
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
}

-(UIView *)setupHeaderView{
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREENWIDTH, 190);
    if( _selectedBtn.tag == 101 ||_selectedBtn.tag == 102){
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180) delegate:self placeholderImage:[UIImage imageNamed:@"占位图"]];
        [header addSubview:_bannerView];
        _bannerView.showPageControl = YES;
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        UIView *lineView = [UIView new];
        [header addSubview:lineView];
        lineView.backgroundColor = GlobalLightGreyColor;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(_bannerView.mas_bottom);
            make.height.mas_equalTo(5);
            make.width.mas_equalTo(SCREENWIDTH);
        }];
    
    }else{
        header.frame = CGRectMake(0, 0, SCREENWIDTH, 0);
    }
    return header;
}

-(void)getData{
    NSLog(@"%@",BaseUrl(NewsList));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":NewsList,
                           @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                           @"pageSize":@10 ,
                                           @"lottery_game_id": [NSString stringWithFormat:@"%zd",self.selectedBtn.tag]}
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(NewsList) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [self.tableView setTableHeaderView:[self setupHeaderView]];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                _dataSource = [ACPNewsListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"skills_list"][@"rows"]];
                if(_selectedBtn.tag == 101 ||_selectedBtn.tag == 102){
                    NSMutableArray *imageURLArr = [NSMutableArray array];
                    NSInteger num = 0;
                    for(ACPNewsListDataModel *dataModel in _dataSource){
                        
                        if(num < 10){
                            if([dataModel.pictures_link isNotNil]){
                                [imageURLArr addObject:dataModel.pictures_link];
                            }
                        }
                        num++;
                    }
                    _bannerView.imageURLStringsGroup = imageURLArr;
                }
            }else{ 
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr = [ACPNewsListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"skills_list"][@"rows"]];
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

-(void)getTitleData{
    
    NSLog(@"%@",BaseUrl(NewsTypeList));
    
    NSDictionary *parameters = @{
                                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                                 @"uri":NewsTypeList,
                                 @"paramData":@{}
                                 };
    
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(NewsTypeList) parameters:parameters success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            NSArray * titleArr = [ACPNewsTitleDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data_content"]];
            self.didTitleViewGetDataBlock(titleArr.copy);
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}

-(void)setupTItleView{
    
    UIView *titleView = [UIView new];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UIScrollView *scrollView = [UIScrollView new];
    [titleView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
     __weak __typeof__(self) weakSelf = self;
    
    self.didTitleViewGetDataBlock = ^(NSArray<ACPNewsTitleDataModel *> *titleArr) {
      
        scrollView.contentSize = CGSizeMake(((SCREENWIDTH -20)/ 3 + 10) * titleArr.count, 50);
        
        for(int i = 0 ;i < titleArr.count;i++){
            ACPNewsTitleDataModel *model = titleArr[i];
            UIButton *btn = [UIButton new];
            [scrollView addSubview:btn];
            btn.frame = CGRectMake(((SCREENWIDTH -20)/ 3 + 10) * i, 0, (SCREENWIDTH -20)/3, 50);
            [btn setTitle:model.news_skill_describe forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:GlobalRedColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            btn.tag = [model.Id integerValue];
            [btn addTarget:weakSelf action:@selector(didClickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.selected = YES;
                weakSelf.selectedBtn = btn;
                [weakSelf getData];
            }
        }
    };
}

-(void)didClickTitleBtn:(UIButton *)sender{
    if(sender.tag == self.selectedBtn.tag){
        return;
    }
    _pageNum = 1;
    sender.selected = YES;
    self.selectedBtn.selected = NO;
    self.selectedBtn = sender;
    [self getData];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ACPNewsListDataModel *model = _dataSource[index];
    ACPNewsDetailViewController *detailVC = [ACPNewsDetailViewController new];
    detailVC.newsId = model.Id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ACPNewsListDataModel *model = _dataSource[indexPath.row];
    ACPNewsDetailViewController *detailVC = [ACPNewsDetailViewController new];
    detailVC.newsId = model.Id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return _dataSource.count;
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPNewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsListCell" forIndexPath:indexPath];
    ACPNewsListDataModel *dataModel = self.dataSource[indexPath.row];
    cell.dataModel = dataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
