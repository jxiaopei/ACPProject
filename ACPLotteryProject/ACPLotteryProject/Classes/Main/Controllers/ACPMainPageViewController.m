//
//  ACPMainPageViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPMainPageViewController.h"
#import <SDCycleScrollView.h>
#import "ACPMainPageDataModel.h"
#import "LCMarqueView.h"
#import "ACPMianPageCollectionViewCell.h"
#import "ACPMainPageLotteryCell.h"
#import "ACPLotteryViewController.h"
#import "ACPLotteryHistroyViewController.h"
#import "ACPActionViewController.h"
#import "ACPTrendViewController.h"
#import "ACPNewsListViewController.h"
#import "ACPBaseWebViewController.h"
#import "ACPLotteryTypeViewController.h"
#import "ACPBBSViewController.h"

@interface ACPMainPageViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)ACPMainPageDataModel *dataModel;
//轮播banner
@property(nonatomic,strong)LCMarqueView *mar;
@property(nonatomic,strong)SDCycleScrollView *bannerView;
//图标
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *dataArr;
//中间广告
@property(nonatomic,strong)SDCycleScrollView *advertismentView;
//彩种选择
@property(nonatomic,strong)UICollectionView *lotteryView;

@end

@implementation ACPMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = @[@{@"title": @"开奖",@"detail":@"全国开奖"},@{@"title": @"活动",@"detail":@"活动上新"},@{@"title": @"社区",@"detail":@"新帖"},@{@"title": @"走势图",@"detail":@"提点遗漏"},@{@"title": @"资讯",@"detail":@"更新"}];
    [self setupNavigationTitleView];
    [self setupScrollView];
    [self setupBannerView];
    [self setupCollectionView];
    [self setupAdvertimentsView];
    [self setupLotteryView];
    [self getData];
}

-(void)setupNavigationTitleView{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0 , 0, 95, 37);
    self.navigationItem.titleView = view;
    UIImageView *imageview = [ UIImageView new];
    imageview.frame = CGRectMake(0 ,0, 95, 37);
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageview];
    imageview.image = [UIImage imageNamed:@"titleViewLogo"];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(HomepageUrl));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":HomepageUrl,
                           @"paramData":@{}
                           };
   
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(HomepageUrl) parameters:dict success:^(id responseObject) {
        [_scrollview.mj_header endRefreshing];
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            _dataModel = [ACPMainPageDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            NSMutableArray *imageArr = [NSMutableArray array];
            [imageArr removeAllObjects];
            for(ACPBannerDataModel *bannerModel in _dataModel.banner){
                if(SCREENWIDTH >= 375){
                    [imageArr addObject:bannerModel.banner_image_url];
                }else{
                    [imageArr addObject:bannerModel.banner_image_url_tow];
                }
            }
            _bannerView.imageURLStringsGroup = imageArr;
            _mar.runString = _dataModel.marque;
            NSMutableArray *advImageArr = [NSMutableArray array];
            [advImageArr removeAllObjects];
            for(ACPAdvertimentModel *advModel in _dataModel.lottery_activity){
                if(SCREENWIDTH >= 375){
                    [advImageArr addObject:advModel.act_pic_url];
                }else{
                    [advImageArr addObject:advModel.act_pic_url_tow];
                }
            }
            _advertismentView.imageURLStringsGroup = advImageArr;
            [_lotteryView reloadData];
        }
    } fail:^(NSError *error) {
        [_scrollview.mj_header endRefreshing];
    }];
}

-(void)setupScrollView{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    _scrollview = scrollView;
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, 785);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    _scrollview.mj_header = header;
}

-(void)setupBannerView{
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180) delegate:self placeholderImage:[UIImage imageNamed:@"占位图"]];
    [_scrollview addSubview:_bannerView];
    _bannerView.showPageControl = YES;
    _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _bannerView.tag = 1000;
    _mar = [[LCMarqueView alloc]initWithFrame:CGRectMake(0, 180, SCREENWIDTH, 25)];
    [self.scrollview addSubview:_mar];
    
    UIView *lineView1 = [UIView new];
    [self.scrollview addSubview:lineView1];
    lineView1.backgroundColor = GlobalLightGreyColor;
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_mar.mas_bottom);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(SCREENWIDTH);
    }];
}

-(void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREENWIDTH - 4)/5, 105);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 210, SCREENWIDTH, 145) collectionViewLayout:layout];
    [_scrollview addSubview:collectionView];
    collectionView.tag = 100;
    collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView = collectionView;
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setContentInset:UIEdgeInsetsMake(20, 2, 20, 2)];
    [collectionView registerClass:[ACPMianPageCollectionViewCell class] forCellWithReuseIdentifier:@"mainPageCell"];
    
//    UIView *verView = [UIView new];
//    [_scrollview addSubview:verView];
//    verView.frame = CGRectMake(10, 225, 2, 15);
//    verView.backgroundColor = [UIColor redColor];;
//
//    UILabel *titleLabel = [UILabel new];
//    [_scrollview addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(verView.mas_right).mas_offset(5);
//        make.centerY.mas_equalTo(verView.mas_centerY);
//    }];
//    titleLabel.font = [UIFont systemFontOfSize:13];
//    titleLabel.text = @"其他服务";
    
    UIView *lineView = [UIView new];
    [_scrollview addSubview:lineView];
    lineView.frame = CGRectMake(0, 355, SCREENWIDTH, 5);
    lineView.backgroundColor = GlobalLightGreyColor;
}

-(void)setupAdvertimentsView{
    _advertismentView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 360, SCREENWIDTH, 140) delegate:self placeholderImage:[UIImage imageNamed:@"占位图"]];
    [_scrollview addSubview:_advertismentView];
    _advertismentView.showPageControl = YES;
    _advertismentView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _advertismentView.tag = 2000;
    UIView *lineView = [UIView new];
    [_scrollview addSubview:lineView];
    lineView.frame = CGRectMake(0, 500, SCREENWIDTH, 5);
    lineView.backgroundColor = GlobalLightGreyColor;
}

-(void)setupLotteryView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREENWIDTH - 4)/3, 85);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 510, SCREENWIDTH, 275) collectionViewLayout:layout];
    [_scrollview addSubview:collectionView];
    collectionView.tag = 200;
    collectionView.backgroundColor = [UIColor whiteColor];
    _lotteryView = collectionView;
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setContentInset:UIEdgeInsetsMake(10, 2, 10, 2)];
    [collectionView registerClass:[ACPMainPageLotteryCell class] forCellWithReuseIdentifier:@"lotteryCell"];
    
//    UIView *verView = [UIView new];
//    [_scrollview addSubview:verView];
//    verView.frame = CGRectMake(10, 505, 2, 15);
//    verView.backgroundColor = [UIColor redColor];;
//
//    UILabel *titleLabel = [UILabel new];
//    [_scrollview addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(verView.mas_right).mas_offset(5);
//        make.centerY.mas_equalTo(verView.mas_centerY);
//    }];
//    titleLabel.font = [UIFont systemFontOfSize:13];
//    titleLabel.text = @"全部彩种";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mar startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mar stopAnimation];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if(cycleScrollView.tag == 2000){
        ACPAdvertimentModel *advModel = _dataModel.lottery_activity[index];
        if(![advModel.act_link_ur isNotNil]){
            [MBProgressHUD showSuccess:@"敬请期待"];
        }else{
            ACPBaseWebViewController *webVc = [[ACPBaseWebViewController alloc] init];
            webVc.urlString = advModel.act_link_ur;
            webVc.title = advModel.act_name;
            [self.navigationController pushViewController:webVc animated:YES];
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 100){
        switch (indexPath.item) {
            case 0:{//开奖
                ACPLotteryViewController *lotteryVc = [ACPLotteryViewController new];
                [self.navigationController pushViewController:lotteryVc animated:YES];
                
            }break;
            case 1:{
                ACPActionViewController *actionVC = [ACPActionViewController new];
                [self.navigationController pushViewController:actionVC animated:YES];
            }break;
            case 2:{//社区
                ACPBBSViewController *BBSVC = [ACPBBSViewController new];
                [self.navigationController pushViewController:BBSVC animated:YES];
            }break;
            case 3:{
                ACPTrendViewController *trendVC = [ACPTrendViewController new];
                trendVC.titleArr =  _dataModel.lottery_game_list;
                ACPMainPageLotteryDataModel *model = _dataModel.lottery_game_list[0];
                trendVC.lotteryId = model.Id;
                trendVC.lotteryName = model.lottery_name;
                [self.navigationController pushViewController:trendVC animated:YES];
            }break;
            default:{
                ACPNewsListViewController *newsListVC = [ACPNewsListViewController new];
                [self.navigationController pushViewController:newsListVC animated:YES];
            }break;
        }
    }else if (collectionView.tag == 200){
        switch (indexPath.item) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            {
                ACPMainPageLotteryDataModel *dataModel = _dataModel.lottery_game_list[indexPath.item];
                ACPLotteryHistroyViewController *histroyVC = [ACPLotteryHistroyViewController new];
                histroyVC.typeId =  dataModel.Id;
                histroyVC.titleStr = dataModel.lottery_name;
                [self.navigationController pushViewController:histroyVC animated:YES];
            }break;
            default:{
                ACPLotteryTypeViewController *allLotteryVC = [ACPLotteryTypeViewController new];
                [self.navigationController pushViewController:allLotteryVC animated:YES];
//                AllLotteryTpyeViewController *moreVc = [[AllLotteryTpyeViewController alloc] init];
//                moreVc.titleArr = _dataModel.lottery_game_list;
//                [self.navigationController pushViewController:moreVc animated:YES];
            }
                break;
        }
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 100 ){
        return _dataArr.count;
    }else{
        return 9;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 100){
       
        ACPMianPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainPageCell" forIndexPath:indexPath];
        cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"service_icon_%zd",indexPath.item + 1]];
        cell.title.text = _dataArr[indexPath.item][@"title"];
        cell.detailText.text = _dataArr[indexPath.item][@"detail"];
        return cell;
    }else{
        ACPMainPageLotteryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lotteryCell" forIndexPath:indexPath];
        if(indexPath.item < 8){
            ACPMainPageLotteryDataModel *dataModel = _dataModel.lottery_game_list[indexPath.item];
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:dataModel.lottery_image_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
            cell.title.text = dataModel.lottery_name;
        }else if(indexPath.item == 8){
            cell.iconView.image = [UIImage imageNamed:@"service_icon_more"];
            cell.title.text = @"全部彩种";
        }
        return cell;
    }
}

@end
