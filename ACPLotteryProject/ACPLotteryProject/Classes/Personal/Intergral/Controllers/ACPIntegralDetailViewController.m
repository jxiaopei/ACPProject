//
//  ACPIntegralDetailViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/10.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPIntegralDetailViewController.h"
#import "ACPIntegralDetailModel.h"
#import "ACPIntegralDetailTableViewCell.h"

@interface ACPIntegralDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)NSMutableArray <ACPIntegralDetailModel *>*dataArr;
@property(nonatomic,assign)NSInteger currentRankType;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIView *underLineView;

@end

@implementation ACPIntegralDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:@"积分明细"];
    [self setupTableView];
    [self setupTitleView];
    _pageNum = 1;
    _currentRankType = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataWithRankType:_currentRankType];
}


-(void)getDataWithRankType:(NSInteger)rankType{
    NSLog(@"%@",BaseUrl(IntegralDetail));
 
//    NSString *rankTypeStr = [NSString stringWithFormat:@"%zd",rankType];
    
    NSArray *arr = @[@"",@"cost",@"10",@"1"];
    NSDictionary *dict =  nil;
    if(_currentRankType == 0){
        dict = @{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":IntegralDetail,
                 @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                 @"pageSize":@5,
                                 @"user_account" :[ACPUserModel shareModel].userAccount}
                 };
    }else{
        dict = @{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":IntegralDetail,
                 @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                 @"pageSize":@5,
                                 @"operation_type" : arr[_currentRankType],
                                 @"user_account" :[ACPUserModel shareModel].userAccount}
                 };
    }
   
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(IntegralDetail) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                self.dataArr =  [ACPIntegralDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"resultData"][@"pointTransList"][@"rows"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =  [ACPIntegralDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"resultData"][@"pointTransList"][@"rows"]];
                if(!mutableArr.count)
                {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                    [self.dataArr addObjectsFromArray:mutableArr];
                }
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

-(void)setupTitleView{
    UIView *titleView = [UIView new];
    [self.view addSubview:titleView];
    titleView.backgroundColor = [UIColor whiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    UIView *lineView = [UIView new];
    [titleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    lineView.backgroundColor = GlobalLightGreyColor;
    
    NSArray *titleArr = @[@"全部",@"赠送",@"花费",@"签到"];
    for(int i = 0; i < titleArr.count;i++){
        UIButton *titleBtn = [UIButton new];
        [titleView addSubview:titleBtn];
        CGFloat margant = 20;
        titleBtn.frame = CGRectMake(((SCREENWIDTH - 3 * margant) /4 + margant) * i,5, (SCREENWIDTH - 3 * margant) /4, 35);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        titleBtn.tag = 1000 + i;
        [titleBtn addTarget:self action:@selector(didClickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            titleBtn.selected = YES;
            _selectedBtn = titleBtn;
            
            UIView *underLineView = [UIView new];
            [titleView addSubview:underLineView];
            _underLineView = underLineView;
            underLineView.frame = CGRectMake(0, 40, (SCREENWIDTH - 3 * margant) /4, 3);
            underLineView.backgroundColor = GlobalRedColor;
        }
    }
    
}

-(void)didClickTitleBtn:(UIButton *)sender{
    
    if([sender.titleLabel.text isEqualToString:_selectedBtn.titleLabel.text]){
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat margant = 20;
        _underLineView.frame = CGRectMake(((SCREENWIDTH - 3 * margant) /4 + margant) *(sender.tag -1000) , 40, (SCREENWIDTH - 3 * margant) /4, 3);
    }];
    sender.selected = YES;
    _selectedBtn.selected = NO;
    _selectedBtn = sender;
    _pageNum = 1;
    _currentRankType = sender.tag - 1000;
    [self getDataWithRankType:_currentRankType];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.frame = CGRectMake(0, 45, SCREENWIDTH, SCREENHEIGHT- 64 - 45);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ACPIntegralDetailTableViewCell class] forCellReuseIdentifier:@"integralDetailCell"];
    _tableView = tableView;

    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self getDataWithRankType:_currentRankType];
    }];
    tableView.mj_header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        _pageNum++;
        
        [self getDataWithRankType:_currentRankType];
    }];
    tableView.mj_footer = footer;
    tableView.tableFooterView = [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACPIntegralDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"integralDetailCell" forIndexPath:indexPath];
    ACPIntegralDetailModel *dataModel = self.dataArr[indexPath.row];
    cell.dataModel = dataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSMutableArray <ACPIntegralDetailModel *>*)dataArr
{
    if(_dataArr == nil)
    {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
