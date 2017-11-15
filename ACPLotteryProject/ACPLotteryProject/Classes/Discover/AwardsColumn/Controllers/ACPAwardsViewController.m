//
//  ACPAwardsViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/6.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPAwardsViewController.h"
#import "ACPAwardsDataModel.h"
#import "ACPAwardsTableViewCell.h"
#import "ACPBaseWebViewController.h"
#import "ACPBannerViewCell.h"
#import "ACPAwardsDetailViewController.h"

@interface ACPAwardsViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)NSMutableArray <ACPAwardsDataModel *> *dataSource;
//轮播
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UICollectionView *bannerView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger page;
@end

@implementation ACPAwardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    [self customBackBtn];
    [self customTitleWith:@"大奖专区"];
    [self setupTableView];
    [self getData];
}

-(void)getData{
    
    NSLog(@"%@",BaseUrl(AwardsColumn));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":AwardsColumn,
                           @"paramData":@{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                                          @"pageSize":@6,
                                          @"type_id" :@2}
                           };
    
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(AwardsColumn) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            _dataArr = [NSMutableArray array];
            [_dataArr addObject:responseObject[@"data"][@"picture_link"]];
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                _dataSource = [ACPAwardsDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data_content"][@"rows"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr = [ACPAwardsDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data_content"][@"rows"]];
                if(!mutableArr.count)
                {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                    [self.dataSource addObjectsFromArray:mutableArr];
                }
            }
            [_tableView reloadData];
            [_bannerView reloadData];
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
    [tableView registerClass:[ACPAwardsTableViewCell class] forCellReuseIdentifier:@"awardsColumnCell"];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 100;
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
    tableView.tableHeaderView = [self setupBannerView];
}

-(UIView *)setupBannerView{
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREENWIDTH, 180);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH, 180);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *bannerView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180) collectionViewLayout:layout];
    [header addSubview:bannerView];
    bannerView.backgroundColor = [UIColor whiteColor];
    _bannerView = bannerView;
    _bannerView.tag =100;
    bannerView.pagingEnabled = YES;
    bannerView.delegate = self;
    bannerView.dataSource = self;
    [bannerView registerClass:[ACPBannerViewCell class] forCellWithReuseIdentifier:@"bannerViewCell"];
    [self setupTimer];
    return header;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACPBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerViewCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[0]] placeholderImage:[UIImage imageNamed:@"占位图"]];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView.tag == 100){
        //停止定时器
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.tag == 100 ){
        [self setupTimer];
        
    }
}



-(void)setupTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage{
    if (_page >= self.dataArr.count - 1) {
        _page = 0;
    }else{
        _page++;
    }
    CGFloat offsetX = _page * SCREENWIDTH;
    [self.bannerView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPAwardsDataModel *model = _dataSource [indexPath.row];
    ACPAwardsDetailViewController *awardDetailVC = [ACPAwardsDetailViewController new];
    awardDetailVC.titleStr = [NSString stringWithFormat:@"%@%@",model.lottery_name,model.type_name];
    awardDetailVC.awardID = model.Id;
    [self.navigationController pushViewController:awardDetailVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ACPAwardsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"awardsColumnCell" forIndexPath:indexPath];
    ACPAwardsDataModel *dataModel = _dataSource [indexPath.row];
    cell.dataModel = dataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
