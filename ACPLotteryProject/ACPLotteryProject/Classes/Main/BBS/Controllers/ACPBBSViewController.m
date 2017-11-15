//
//  ACPBBSViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBBSViewController.h"
#import "ACPBBSListDataModel.h"
#import "ACPBBSListTableViewCell.h"
#import "ACPLoginViewController.h"
#import "ACPSecurityHeaderView.h"
#import "ACPConcernedNoDataCell.h"
#import "ACPConcernedDataModel.h"
#import "ACPRecommendConDataModel.h"
#import "ACPConcernedTableViewCell.h"
#import "ACPBBSPersonalViewController.h"
#import "ACPBBSDetailViewController.h"
#import "ACPBBSListTopTableViewCell.h"
#import "ACPBBSImageCollectionViewCell.h"


@interface ACPBBSViewController ()<UITableViewDelegate,UITableViewDataSource,SDPhotoBrowserDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIView *underLineView;

@property(nonatomic,strong)UITableView *attentionTableView;
@property(nonatomic,strong)NSMutableArray <ACPConcernedDataModel *>*attenDataSource;
@property(nonatomic,assign)NSInteger attenPageNum;

@property(nonatomic,strong)UITableView *recommendTableView;
@property(nonatomic,strong)NSMutableArray <ACPRecommendConDataModel *>*recommendDataSource;
//@property(nonatomic,assign)NSInteger recommendPageNum;
@property(nonatomic,strong)UIView *recommendTitleView;

@property(nonatomic,strong)NSMutableArray <ACPBBSListDataModel *>*dataSource;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageNum;

@property(nonatomic,strong)NSMutableArray *browserImageArr;
@property(nonatomic,strong)NSMutableArray *browserImgUrlArr;

@end

@implementation ACPBBSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    _attenPageNum = 1;
    [self setupNavigationItem];
    [self setupScrollView];
    [self setupTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
    [self getAttentionData];
    [self getRecommendAttentionData];
    if([ACPUserModel shareModel].isLogin){
        [_loginBtn sd_setImageWithURL:[NSURL URLWithString:BaseUrl([ACPUserModel shareModel].imageUrl)] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    if(_scrollView.contentOffset.x == SCREENWIDTH){
        
    }
}

-(void)getData{
    NSLog(@"%@",BaseUrl(CommunityList));
    NSString *uid = [ACPUserModel shareModel].uid ? [ACPUserModel shareModel].uid : @"";
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":CommunityList,
                           @"paramData":@{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                                          @"pageSize":@6,
                                          @"user_id":uid}
                           };
    
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(CommunityList) parameters:dict success:^(id responseObject) {
        
//        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                _dataSource = [ACPBBSListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr = [ACPBBSListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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

-(void)getAttentionData{
    if([ACPUserModel shareModel].isLogin){
        NSLog(@"%@",BaseUrl(ConcernedList));
        NSDictionary *dict = @{
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                               @"uri":ConcernedList,
                               @"paramData":@{@"pageNum":[NSNumber numberWithInteger:_attenPageNum],
                                              @"pageSize":@6,
                                              @"fans_id":@([ACPUserModel shareModel].uid.integerValue),
                                              @"user_me_id":@([ACPUserModel shareModel].uid.integerValue),
                                              }
                               };
        [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(ConcernedList) parameters:dict success:^(id responseObject) {
            
            Log_ResponseObject;
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
                
                if(_attenPageNum == 1){
                  [_attentionTableView.mj_header endRefreshing];
                  [_attentionTableView.mj_footer endRefreshing];
                  _attenDataSource = [ACPConcernedDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                }else{
                    NSMutableArray *mutableArr = [NSMutableArray array];
                    mutableArr =  [ACPConcernedDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                    if(!mutableArr.count)
                    {
                        [_attentionTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_attentionTableView.mj_footer endRefreshing];
                        [self.attenDataSource addObjectsFromArray:mutableArr];
                    }
                }
                
                if(_attenDataSource.count == 0){
                    [UIView animateWithDuration:0.5 animations:^{
                        _attentionTableView.frame = CGRectMake(SCREENWIDTH, 30, SCREENWIDTH, 100);
                        _recommendTitleView.frame = CGRectMake(SCREENWIDTH, 130, SCREENWIDTH, 30);
                        _recommendTableView.frame = CGRectMake(SCREENWIDTH, 160, SCREENWIDTH, SCREENHEIGHT - 160 - 64);
                    }];
                }else{
                    [UIView animateWithDuration:0.5 animations:^{
                        NSInteger row = _attenDataSource.count > 3 ? 3 :_attenDataSource.count;
                        _attentionTableView.frame = CGRectMake(SCREENWIDTH, 30, SCREENWIDTH, 80 * row);
                        _recommendTitleView.frame = CGRectMake(SCREENWIDTH, 30 + 80 * row, SCREENWIDTH, 30);
                        _recommendTableView.frame = CGRectMake(SCREENWIDTH, 60 + 80 * row, SCREENWIDTH, SCREENHEIGHT - 60 + 80 * row - 64);
                    }];
                }
                [_attentionTableView reloadData];
            }else{
                [_attentionTableView.mj_header endRefreshing];
                [_attentionTableView.mj_footer endRefreshing];
            }
        } fail:^(NSError *error) {
            [_attentionTableView.mj_header endRefreshing];
            [_attentionTableView.mj_footer endRefreshing];
        }];
        
    }else{
        [_attentionTableView.mj_header endRefreshing];
        [_attentionTableView.mj_footer endRefreshing];
    }
}

-(void)getRecommendAttentionData{
    NSLog(@"%@",BaseUrl(RecommendConList));
    NSString *uid = [ACPUserModel shareModel].uid ? [ACPUserModel shareModel].uid : @"";
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":RecommendConList,
                           @"paramData":@{@"fans_id":uid}
                           };
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(RecommendConList) parameters:dict success:^(id responseObject) {
        
        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [_recommendTableView.mj_header endRefreshing];
            [_recommendDataSource removeAllObjects];
            _recommendDataSource = [ACPRecommendConDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            for(int i =0;i < _recommendDataSource.count;i++){
                ACPRecommendConDataModel *dataModel = _recommendDataSource[i];
                if(dataModel.user_concerned == 1){
                    [_recommendDataSource removeObjectAtIndex:i];
                    i--;
                }
            }
            [_recommendTableView reloadData];
        }else{
            [_recommendTableView.mj_header endRefreshing];
        }
    } fail:^(NSError *error) {
        [_recommendTableView.mj_header endRefreshing];
        
    }];
}

-(void)didAttentionActionWithDataModel:(ACPRecommendConDataModel *)dataModel sender:(UIButton *)sender{
    
    if(![ACPUserModel shareModel].isLogin){
        [self loginAction];
        sender.enabled = YES;
        return;
    }
    for(ACPConcernedDataModel *attentionModel in _attenDataSource){
        if([attentionModel.user_id isEqualToString:dataModel.Id])
        {
            [MBProgressHUD showError:@"你已经关注过此账号了"];
            sender.enabled = YES;
            return ;
        }
    }
    
    if([[ACPUserModel shareModel].uid isEqualToString:dataModel.Id]){
        [MBProgressHUD showError:@"自己无法关注自己的哦"];
        sender.enabled = YES;
        return ;
    }
    
    NSLog(@"%@",BaseUrl(AddConcerned));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":AddConcerned,
                           @"paramData":@{@"fans_id":@([ACPUserModel shareModel].uid.integerValue),
                                          @"user_id":dataModel.Id}
                           };
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(AddConcerned) parameters:dict success:^(id responseObject) {
        sender.enabled = YES;
        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"关注成功"];
            [self getAttentionData];
            [self getRecommendAttentionData];
        }else{
           [MBProgressHUD showError:@"关注失败"];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络错误"];
    }];
}

-(void)cancelAttentionActionWithDataModel:(ACPConcernedDataModel *)dataModel sender:(UIButton *)sender{
    NSLog(@"%@",BaseUrl(RemoveConcerned));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":RemoveConcerned,
                           @"paramData":@{@"fans_id":@([ACPUserModel shareModel].uid.integerValue),
                                          @"user_id":dataModel.user_id}
                           };
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(RemoveConcerned) parameters:dict success:^(id responseObject) {
        sender.enabled = YES;
        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"取消关注成功"];
            [self getAttentionData];
            [self getRecommendAttentionData];
        }else{
            [MBProgressHUD showError:@"取消关注失败"];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        sender.enabled = YES;
    }];
}

-(void)setupNavigationItem{
    [self customBackBtn];
    UIView *titleView = [UIView new];
    titleView.frame = CGRectMake(0 , 0, 160, 40);
    _titleView = titleView;
    self.navigationItem.titleView = titleView;
    NSArray *titleArr = @[@"热帖",@"关注"];
    for(int i = 0; i < titleArr.count;i++){
        UIButton *titleBtn = [UIButton new];
        [titleView addSubview:titleBtn];
        titleBtn.frame = CGRectMake(80 * i,0, 80, 35);
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(didClickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            titleBtn.selected = YES;
            _selectedBtn = titleBtn;
            UIView *underLineView = [UIView new];
            [titleView addSubview:underLineView];
            _underLineView = underLineView;
            underLineView.frame = CGRectMake(0, 40, 80, 3);
            underLineView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    UIButton *loginBtn = [UIButton new];
    _loginBtn = loginBtn;
    loginBtn.frame = CGRectMake(0, 0, 30, 30);
    [loginBtn setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 15;
    loginBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [loginBtn addTarget:self action:@selector(didClickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:loginBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

-(void)didClickLeftBtn:(UIButton *)sender{
    if(![ACPUserModel shareModel].isLogin){
        [self loginAction];
    }else{
        ACPBBSPersonalViewController *BBSPersonalVC = [ACPBBSPersonalViewController new];
        BBSPersonalVC.userId = [ACPUserModel shareModel].uid;
        BBSPersonalVC.userImageUrl = [ACPUserModel shareModel].imageUrl;
        BBSPersonalVC.userName = [ACPUserModel shareModel].userName;
        BBSPersonalVC.introduction = [ACPUserModel shareModel].introduction;
        [self.navigationController pushViewController:BBSPersonalVC animated:YES];
    }
}

-(void)loginAction{
    ACPLoginViewController *loginVC = [ACPLoginViewController new];
    loginVC.popVC = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)setupScrollView
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    scrollView.tag = 1000;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(SCREENWIDTH *2, SCREENHEIGHT - 64);
}

-(void)setupTableView
{
    for(int i = 0;i < 3;i++)
    {
        UITableView *tableView = [UITableView new];
        [_scrollView addSubview:tableView];
        tableView.tag = i;
        if(i == 0){
            self.tableView = tableView;
            tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
            [tableView registerClass:[ACPBBSListTableViewCell class] forCellReuseIdentifier:@"BBSListCell"];
            [tableView registerClass:[ACPBBSListTopTableViewCell class] forCellReuseIdentifier:@"BBSTopCell"];
        }else if (i == 1){
            UIView *titleView = [UIView new];
            [self.scrollView addSubview:titleView];
            titleView.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, 30);
            UILabel *titleLabel = [UILabel new];
            [titleView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(10);
            }];
            titleLabel.text = @"我的关注";
            UIView *lineView = [UIView new];
            [titleView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(2);
            }];
            lineView.backgroundColor = GlobalLightGreyColor;
            self.attentionTableView = tableView;
            tableView.frame = CGRectMake(SCREENWIDTH, 30, SCREENWIDTH, 100);
            [tableView registerClass:[ACPConcernedTableViewCell class] forCellReuseIdentifier:@"attentionListCell"];
            [tableView registerClass:[ACPConcernedNoDataCell class] forCellReuseIdentifier:@"concernedNoDataCell"];
        }else if (i == 2){
            UIView *titleView = [UIView new];
            [self.scrollView addSubview:titleView];
            titleView.frame = CGRectMake(SCREENWIDTH, 130, SCREENWIDTH, 30);
            _recommendTitleView = titleView;
            UILabel *titleLabel = [UILabel new];
            [titleView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(10);
            }];
            titleLabel.text = @"推荐关注";
            UIView *lineView = [UIView new];
            [titleView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(2);
            }];
            lineView.backgroundColor = GlobalLightGreyColor;
            self.recommendTableView = tableView;
            [tableView registerClass:[ACPConcernedTableViewCell class] forCellReuseIdentifier:@"recommendListCell"];
            tableView.frame = CGRectMake(SCREENWIDTH, 160, SCREENWIDTH, SCREENHEIGHT - 160 - 64);
        }
        
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            if(tableView.tag == 0){
                _pageNum = 1;
                [self getData];
            }else if (tableView.tag == 1){
                _attenPageNum = 1;
                [self getAttentionData];
            }else{
                [self getRecommendAttentionData];
            }
            
        }];
        tableView.mj_header = header;
        if(tableView.tag == 0){
            MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                
                if(tableView.tag == 0){
                    _pageNum ++;
                    [self getData];
                }else if (tableView.tag == 1){
                    _attenPageNum ++;
                    [self getAttentionData];
                }
            }];
            tableView.mj_footer = footer;
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == 1000)
    {
        CGFloat offsetX =scrollView.contentOffset.x;
        if(offsetX == SCREENWIDTH || offsetX == 0)
        {
            NSInteger tag =  offsetX/SCREENWIDTH;
            for(int i = 0;i < _titleView.subviews.count ; i++)
            {
                if([_titleView.subviews[i] isKindOfClass:[UIButton class]])
                {
                    if(tag == _titleView.subviews[i].tag )
                    {
                        UIButton *btn = _titleView.subviews[i];
                        btn.selected = YES;
                        self.selectedBtn.selected = NO;
                        self.selectedBtn = btn;
                        if([btn.titleLabel.text isEqualToString:@"热帖"])
                        {
                            _pageNum = 1;
                            [self getData];
                        }else if ([btn.titleLabel.text isEqualToString:@"关注"]){
                            if(![ACPUserModel shareModel].isLogin){
                                [self loginAction];
                            }else{
                                _attenPageNum = 1;
                                [self getAttentionData];
                                [self getRecommendAttentionData];
                            }
                        }
                        [self didClickTitleBtn:btn];
                    }
                }
            }
        }
    }
}

-(void)didClickTitleBtn:(UIButton *)sender{
    
    if([sender.titleLabel.text isEqualToString:_selectedBtn.titleLabel.text]){
        return;
    }
    [_scrollView setContentOffset:CGPointMake(sender.tag * SCREENWIDTH, 0) animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        _underLineView.frame = CGRectMake(80 *(sender.tag) , 40, 80, 3);
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 0){
        ACPBBSDetailViewController *BBSDetailVC = [ACPBBSDetailViewController new];
        ACPBBSListDataModel *model = _dataSource[indexPath.row];
        BBSDetailVC.userId = model.user_id;
        BBSDetailVC.Id = model.Id;
        [self.navigationController pushViewController:BBSDetailVC animated:YES];
    }else if(tableView.tag == 1 ){
        if(![ACPUserModel shareModel].isLogin){
            return;
        }
        ACPConcernedDataModel *dataModel = _attenDataSource[indexPath.row];
        ACPBBSPersonalViewController *BBSPersonalVC = [ACPBBSPersonalViewController new];
        BBSPersonalVC.userId = dataModel.user_id;
        BBSPersonalVC.userImageUrl = dataModel.user_image_url;
        BBSPersonalVC.userName = dataModel.user_name;
        BBSPersonalVC.introduction = dataModel.user_brief_introduction;
        [self.navigationController pushViewController:BBSPersonalVC animated:YES];
    }else{
        ACPRecommendConDataModel *dataModel = _recommendDataSource[indexPath.row];
        ACPBBSPersonalViewController *BBSPersonalVC = [ACPBBSPersonalViewController new];
        BBSPersonalVC.userId = dataModel.Id;
        BBSPersonalVC.userImageUrl = dataModel.user_image_url;
        BBSPersonalVC.userName = dataModel.user_name;
        BBSPersonalVC.introduction = dataModel.user_brief_introduction;
        [self.navigationController pushViewController:BBSPersonalVC animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 0){
       return _dataSource.count;
    }else if(tableView.tag == 1){
        return _attenDataSource.count ? _attenDataSource.count : 1;
    }else{
        return _recommendDataSource.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 0){
        ACPBBSListDataModel *model = _dataSource [indexPath.row];
        if(model.community_top){
            ACPBBSListTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSTopCell" forIndexPath:indexPath];
            cell.dataModel = model;
            __weak __typeof__(cell) weakCell = cell;
            cell.didClickHeaderViewBlock = ^{
                [self.browserImageArr removeAllObjects];
                if(model.release_image_url.length <1){
                    return ;
                }
                NSArray *urlArr = [model.release_image_url componentsSeparatedByString:@","];
                if(urlArr.count < 1){
                    
                }
                if(urlArr.count == 1){
                    [self.browserImageArr addObject:weakCell.iconView.image];
                }else{
                    for(int i = 0;i < urlArr.count;i++){
                        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:BaseUrl(urlArr[i])]];
                        UIImage *image = [UIImage imageWithData:imgData];
                        [self.browserImageArr addObject:image];
                    }
                }
                self.browserImgUrlArr = urlArr.copy;
                SDPhotoBrowser *browser = [SDPhotoBrowser new];
                browser.sourceImagesContainerView = weakCell;
                browser.imageCount = urlArr.count;
                browser.currentImageIndex = 0;//当前需要展示图片的index
                browser.delegate = self;
                [browser show];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ACPBBSListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSListCell" forIndexPath:indexPath];
            cell.dataModel = model;
            cell.didClickHeaderViewBlock = ^{
                ACPBBSPersonalViewController *BBSPersonalVC = [ACPBBSPersonalViewController new];
                BBSPersonalVC.userId = model.user_id;
                BBSPersonalVC.userImageUrl = model.user_image_url;
                BBSPersonalVC.userName = model.user_name;
                BBSPersonalVC.introduction = model.user_brief_introduction;
                [self.navigationController pushViewController:BBSPersonalVC animated:YES];
            };
            __weak __typeof__(cell) weakCell = cell;
            cell.didClickCollectionViewCellBlock = ^(NSInteger index){
                NSArray *cellArr = weakCell.collectionView.visibleCells;
                [self.browserImageArr removeAllObjects];;
                for(int i = 0;i < cellArr.count;i++){
                    ACPBBSImageCollectionViewCell *imageCell = ( ACPBBSImageCollectionViewCell *)cellArr[i];
                    [_browserImageArr addObject:imageCell.imageView.image];
                }
                NSArray *urlArr = [model.release_image_url componentsSeparatedByString:@","];
                self.browserImgUrlArr = urlArr.copy;
                SDPhotoBrowser *browser = [SDPhotoBrowser new];
                browser.sourceImagesContainerView = weakCell.collectionView;
                browser.imageCount = cellArr.count;
                browser.currentImageIndex = index;//当前需要展示图片的index
                browser.delegate = self;
                [browser show];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if(tableView.tag == 1 ){
        if(!self.attenDataSource.count){
            ACPConcernedNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"concernedNoDataCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ACPConcernedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attentionListCell" forIndexPath:indexPath];
            ACPConcernedDataModel *dataModel = _attenDataSource[indexPath.row];
            cell.dataModel = dataModel;
            cell.didClickAttentionActionBtnBlock = ^(UIButton *sender){
                sender.enabled = NO;
                [self cancelAttentionActionWithDataModel:dataModel sender:sender];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        ACPConcernedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendListCell" forIndexPath:indexPath];
        ACPRecommendConDataModel *dataModel = _recommendDataSource[indexPath.row];
        cell.recommendDataModel = dataModel;
        cell.didClickAttentionActionBtnBlock = ^(UIButton *sender){
            sender.enabled = NO;
            [self didAttentionActionWithDataModel:dataModel sender:sender];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0){
        ACPBBSListDataModel *model = _dataSource [indexPath.row];
        return model.rowHeight;
    }else if (tableView.tag == 1 && !_attenDataSource.count){
        return 100;
    }
    return 80;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return self.browserImageArr[index];
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return [NSURL URLWithString:BaseUrl(self.browserImgUrlArr[index])];
}

-(NSMutableArray *)browserImageArr{
    if(_browserImageArr == nil){
        _browserImageArr = [NSMutableArray array];
    }
    return _browserImageArr;
}

-(NSMutableArray *)browserImgUrlArr{
    if(_browserImgUrlArr == nil){
        _browserImgUrlArr = [NSMutableArray array];
    }
    return _browserImgUrlArr;
}

@end
