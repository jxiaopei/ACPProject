//
//  ACPRecommendViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPRecommendViewController.h"
#import "ACPPartnerTableViewCell.h"
#import "ACPRecommendModel.h"
#import "ACPBaseWebViewController.h"
#import "ACPBannerViewCell.h"

@interface ACPRecommendViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <ACPRecommendModel *>*dataArr;
//轮播
@property(nonatomic,strong)UICollectionView *bannerView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger page;
@end

@implementation ACPRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTitleWith:@"推荐"];
//    [self setupBannerView];
    [self.view addSubview:self.tableView];
    _page = 0;
    [self getData];
    
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

-(void)getData{
    
    NSLog(@"%@",BaseUrl(RecommendedList));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":RecommendedList,
                           @"paramData":@{}
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(RecommendedList) parameters:dict success:^(id responseObject) {
        [_tableView.mj_header endRefreshing];
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {

            _dataArr = [ACPRecommendModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"recommend_list"]];
//            _pageControl.numberOfPages = _dataArr.count;
            [self.tableView reloadData];
            [self.bannerView reloadData];
        }
        
    } fail:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ACPBaseWebViewController *partnerVC = [ACPBaseWebViewController new];
    partnerVC.title = self.dataArr[indexPath.section].title;
    partnerVC.urlString = [NSString stringWithFormat:@"https://%@",self.dataArr[indexPath.section].link_url];
    [self.navigationController pushViewController:partnerVC animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACPRecommendModel *bannerModel = _dataArr[indexPath.row];
    ACPBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerViewCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.image_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACPPartnerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCPartnerTableViewCell"];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.section].image_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
    cell.titleLabel.text = self.dataArr[indexPath.section].title;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ACPBaseWebViewController *partnerVC = [ACPBaseWebViewController new];
    partnerVC.title = self.dataArr[indexPath.section].title;
    partnerVC.urlString = [NSString stringWithFormat:@"https://%@",self.dataArr[indexPath.section].link_url];
    [self.navigationController pushViewController:partnerVC animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49 - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = GlobalLightGreyColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 5;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.tableHeaderView = [self setupBannerView];
        [_tableView registerClass:[ACPPartnerTableViewCell class] forCellReuseIdentifier:@"LCPartnerTableViewCell"];
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [self getData];
        }];
        _tableView.mj_header = header;
    }
    return _tableView;
}


@end
