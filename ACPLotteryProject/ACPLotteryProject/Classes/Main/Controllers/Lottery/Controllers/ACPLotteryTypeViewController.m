//
//  ACPLotteryTypeViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/24.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPLotteryTypeViewController.h"
#import "ACPLotteryTypeTableViewCell.h"
#import "ACPLotteryListModel.h"
#import "ACPLotteryHistroyViewController.h"
#import "ACPTrendViewController.h"
#import "ACPMainPageLotteryDataModel.h"

@interface ACPLotteryTypeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <ACPLotteryListModel *>*dataSource;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSMutableArray *searchArray;
@property(nonatomic,assign)BOOL isSearch;

@end

@implementation ACPLotteryTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:@"全部彩种"];
    [self setSearchView];
    [self setupTableView];
    [self getData];
    [self setupTimer];
}

-(void)setSearchView{
    _searchArray = [NSMutableArray array];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.tintColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.02 alpha:1.00];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    for (id obj in [_searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        }
    }
    [self.view addSubview:_searchBar];
}

#pragma mark SearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    searchBar.text = @"";
    _isSearch = NO;
    [_tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [_searchArray removeAllObjects];
    for (ACPLotteryListModel *model in _dataSource) {
        if([model.lottery_name rangeOfString:searchBar.text].location != NSNotFound)
        {
            [_searchArray addObject:model];
        }
    }
    if(_searchArray.count == 0)
    {
        [self showToast:@"无搜索结果"];
        return;
    }
    _isSearch = YES;
    [_tableView reloadData];
}
- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in _searchBar.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className])
        {
            return subView;
        }
        return nil;
    } return nil;
    
}

-(void)getData{
    NSLog(@"%@",BaseUrl(AllLotteryList));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":AllLotteryList,
                           @"paramData":@{}
                           };
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(AllLotteryList) parameters:dict success:^(id responseObject) {
        
        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            _dataSource = [ACPLotteryListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lottery_list"]];
            [_tableView reloadData];
        }else{
           
        }
    } fail:^(NSError *error) {
       
    }];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.frame = CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT- 64 - 40);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ACPLotteryTypeTableViewCell class] forCellReuseIdentifier:@"lotteryTypeCell"];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 150;
    tableView.tableFooterView = [UIView new];
}

-(void)setupTimer{
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countSecondAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)countSecondAction{
    for(int i = 0;i < _dataSource.count;i++){
        ACPLotteryListModel *model = _dataSource[i];
        [model countSeconds];
        if(model.lottery_next_time < 1){
            if(model.indexNumber == 0){
                [self requstDataWithIndex:i];
            }else{
                model.indexNumber --;
            }
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"countSecond" object:nil];
}

-(void)requstDataWithIndex:(NSInteger)index{
    NSLog(@"%@",BaseUrl(LotteryRefresh));
    ACPLotteryListModel *model = _dataSource[index];
    model.indexNumber = 8;
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":LotteryRefresh,
                           @"paramData":@{@"nper": model.lottery_nper,
                                          @"id": @(model.lottery_game_id.integerValue),
                                          }
                           };
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(LotteryRefresh) parameters:dict success:^(id responseObject) {
        
//        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            ACPLotteryListModel *dataModel = [ACPLotteryListModel mj_objectWithKeyValues:responseObject[@"data"][@"lottery_list"]];
            if([dataModel.lottery_name isEqualToString:model.lottery_name] && [dataModel.lottery_game_id isEqualToString:model.lottery_game_id]){
                [_dataSource replaceObjectAtIndex:index withObject:dataModel];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }else{
            
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPLotteryHistroyViewController *histroyVC = [ACPLotteryHistroyViewController new];
    ACPLotteryListModel *model = self.dataSource[indexPath.row];
    histroyVC.typeId =  model.lottery_game_id;
    histroyVC.titleStr = model.lottery_name;
    [self.navigationController pushViewController:histroyVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isSearch?_searchArray.count:_dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPLotteryTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lotteryTypeCell" forIndexPath:indexPath];
    ACPLotteryListModel *dataModel = self.dataSource[indexPath.row];
    cell.dataModel = dataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.didClickCollectionViewCellBlock = ^{
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    cell.didClickHistroyBtnBlock = ^{
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    cell.didClickTrendBtnBlock = ^{
        [self didClickTrendBtnWithIndex:indexPath.row];
    };
    return cell;
}

-(void)didClickTrendBtnWithIndex:(NSInteger)index{
    NSMutableArray *mutableArr = [NSMutableArray array];
    NSString *lotteryId = nil;
    NSString *lotteryName = nil;
    for(int i = 0; i < _dataSource.count;i++){
        ACPLotteryListModel *model = _dataSource[i];
        ACPMainPageLotteryDataModel *dataModel = [ACPMainPageLotteryDataModel new];
        dataModel.Id = model.lottery_game_id;
        dataModel.lottery_name = model.lottery_name;
        [mutableArr addObject:dataModel];
        if(i == index){
            lotteryId = model.lottery_game_id;
            lotteryName = model.lottery_name;
        }
    }
    ACPTrendViewController *trendVC = [ACPTrendViewController new];
    trendVC.titleArr =  mutableArr;
    trendVC.lotteryId = lotteryId;
    trendVC.lotteryName = lotteryName;
    [self.navigationController pushViewController:trendVC animated:YES];

}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    ACPLotteryTypeTableViewCell *lotteryCell = (ACPLotteryTypeTableViewCell *)cell;
//    ACPLotteryListModel *dataModel = self.dataSource[indexPath.row];
//    lotteryCell.dataModel = dataModel;
//    lotteryCell.showed = YES;
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    ACPLotteryTypeTableViewCell *lotteryCell = (ACPLotteryTypeTableViewCell *)cell;
//    lotteryCell.showed = NO;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACPLotteryListModel *dataModel = self.dataSource[indexPath.row];
    return dataModel.typeRowHeight + 50;
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

@end
