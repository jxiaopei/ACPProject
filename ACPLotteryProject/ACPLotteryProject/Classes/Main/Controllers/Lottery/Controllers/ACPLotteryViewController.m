//
//  ACPLotteryViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPLotteryViewController.h"
#import "ACPLotteryListModel.h"
#import "ACPLotteryTitleModel.h"
#import "ACPLotteryListTableViewCell.h"
#import "ACPLotteryHistroyViewController.h"

@interface ACPLotteryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray <ACPLotteryTitleModel *>*titleArr;
@property(nonatomic,copy)void(^didTitleViewGetDataBlock)(NSArray <ACPLotteryTitleModel *>*titleArr,NSInteger awardAmout);
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)NSMutableArray <ACPLotteryListModel *>*dataSource;
@property(nonatomic,assign)NSInteger awardAmount;

@end

@implementation ACPLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    [self customTitleWith:@"彩票开奖"];
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
    tableView.frame = CGRectMake(0, 44 + 80, SCREENWIDTH, SCREENHEIGHT- 64 - 44 - 80);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ACPLotteryListTableViewCell class] forCellReuseIdentifier:@"lotteryListCell"];
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

-(void)getData{
    NSLog(@"%@",BaseUrl(LotteryList));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":LotteryList,
                           @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                           @"pageSize":@5 ,
                                           @"lottery_game_id": [NSString stringWithFormat:@"%zd",self.selectedBtn.tag]}
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(LotteryList) parameters:dict success:^(id responseObject) {
        
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

-(void)getTitleData{
    
    NSLog(@"%@",BaseUrl(LotteryTypeList));
    
    NSDictionary *parameters = @{
                                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                                 @"uri":LotteryTypeList,
                                 @"paramData":@{}
                                 };
    
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(LotteryTypeList) parameters:parameters success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            _awardAmount = [responseObject[@"data"][@"total_amount"] integerValue];

            _titleArr = [ACPLotteryTitleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lottery_kind"]];
            self.didTitleViewGetDataBlock(_titleArr,_awardAmount);
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
        make.height.mas_equalTo(44 + 80);
    }];
    
    UIScrollView *scrollView = [UIScrollView new];
    [titleView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    scrollView.backgroundColor = GlobalLightGreyColor;
    
    UILabel *tipLabel = [UILabel new];
    [titleView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    tipLabel.text = @"爱彩票累计中奖...";
    tipLabel.font = [UIFont systemFontOfSize:15];
    
    
    UILabel *awardLabel = [UILabel new];
    [titleView addSubview:awardLabel];
    [awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(tipLabel.mas_top).mas_offset(-5);
    }];


    
    
    __weak __typeof__(self) weakSelf = self;
    
    self.didTitleViewGetDataBlock = ^(NSArray<ACPLotteryTitleModel *> *titleArr,NSInteger awardAmount) {
        
        scrollView.contentSize = CGSizeMake(((SCREENWIDTH - 8)/5 +2) * titleArr.count -2, 44);
        
        for(int i = 0 ;i < titleArr.count;i++){
            ACPLotteryTitleModel *model = titleArr[i];
            UIButton *btn = [UIButton new];
            [scrollView addSubview:btn];
            btn.frame = CGRectMake(((SCREENWIDTH -8)/ 5 + 2) * i, 0, (SCREENWIDTH - 8)/5, 44);
            [btn setTitle:model.lottery_kind_name forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            btn.tag = model.lottery_kind_type;
            [btn addTarget:weakSelf action:@selector(didClickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.selected = YES;
                btn.backgroundColor = GlobalRedColor;
                weakSelf.selectedBtn = btn;
                [weakSelf getData];
            }
        }
        
        NSString *awardStr = [NSString stringWithFormat:@"%zd",awardAmount];
        if(awardStr.length > 8){
            awardLabel.text = [NSString stringWithFormat:@"%zd亿",awardAmount/100000000];
        }else if (awardStr.length > 4){
            awardLabel.text = [NSString stringWithFormat:@"%zd万",awardAmount/10000];
        }else{
            awardLabel.text = [NSString stringWithFormat:@"%zd元", awardAmount];
        }
        awardLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size: 26];
    };
}

-(void)didClickTitleBtn:(UIButton *)sender{
    if(sender.tag == self.selectedBtn.tag){
        return;
    }
    sender.selected = YES;
    sender.backgroundColor = GlobalRedColor;
    self.selectedBtn.backgroundColor = [UIColor whiteColor];
    self.selectedBtn.selected = NO;
    self.selectedBtn = sender;
    _pageNum = 1;
    [self.tableView.mj_header beginRefreshing];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPLotteryListModel *dataModel = self.dataSource[indexPath.row];
    ACPLotteryHistroyViewController *histroyVC = [ACPLotteryHistroyViewController new];
    histroyVC.typeId =  dataModel.lottery_game_id;
    histroyVC.titleStr = dataModel.lottery_name;
    [self.navigationController pushViewController:histroyVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPLotteryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lotteryListCell" forIndexPath:indexPath];
    ACPLotteryListModel *dataModel = self.dataSource[indexPath.row];
    cell.dataModel = dataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.didClickCollectionViewCellBlock = ^{
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACPLotteryListModel *dataModel = self.dataSource[indexPath.row];
    return dataModel.rowHeight;
}




@end
