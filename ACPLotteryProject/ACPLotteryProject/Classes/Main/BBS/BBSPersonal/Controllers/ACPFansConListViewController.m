//
//  ACPFansConListViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/21.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPFansConListViewController.h"
#import "ACPConcernedTableViewCell.h"
#import "ACPConcernedDataModel.h"
#import "ACPBBSPersonalViewController.h"
#import "ACPLoginViewController.h"

@interface ACPFansConListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <ACPConcernedDataModel *>*dataSource;

@end

@implementation ACPFansConListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    if(_listType == FansType){
        [self customTitleWith:@"粉丝列表"];
    }else{
        [self customTitleWith:@"关注列表"];
    }
    _pageNum = 1;
    [self setupTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ACPConcernedTableViewCell class] forCellReuseIdentifier:@"fansConcernedCell"];
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
    
}
-(void)getData{
    NSNumber *userNum = [ACPUserModel shareModel].isLogin ? @([ACPUserModel shareModel].uid.integerValue) : @0;
    if(_listType == FansType){
        NSLog(@"%@",BaseUrl(FansList));
        NSDictionary *dict =@{
                                    @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                                    @"uri":FansList,
                                    @"paramData":@{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                                                   @"pageSize":@6,
                                                   @"user_id":@(_userId.integerValue),
                                                   @"user_me_id" : userNum,
                                                   }
                                    };
        [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(FansList) parameters:dict success:^(id responseObject) {
            
            Log_ResponseObject;
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
                if(_pageNum == 1)
                {
                    [_tableView.mj_header endRefreshing];
                    [_tableView.mj_footer endRefreshing];
                    _dataSource = [ACPConcernedDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                    
                }else{
                    NSMutableArray *mutableArr = [NSMutableArray array];
                    mutableArr = [ACPConcernedDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
        
        
    }else{
        NSLog(@"%@",BaseUrl(ConcernedList));
        NSDictionary *dict =@{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":ConcernedList,
                 @"paramData":@{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                                @"pageSize":@6,
                                @"fans_id":@(_userId.integerValue),
                                @"user_me_id": userNum,
                               }
                 };
    
        [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(ConcernedList) parameters:dict success:^(id responseObject) {
            
            Log_ResponseObject;
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
                if(_pageNum == 1)
                {
                    [_tableView.mj_header endRefreshing];
                    [_tableView.mj_footer endRefreshing];
                    _dataSource = [ACPConcernedDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                    
                }else{
                    NSMutableArray *mutableArr = [NSMutableArray array];
                    mutableArr = [ACPConcernedDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
}

-(void)didAttentionActionWithDataModel:(ACPConcernedDataModel *)dataModel sender:(UIButton *)sender{
    
    if(![ACPUserModel shareModel].isLogin){
        [self loginAction];
        sender.enabled = YES;
        return;
    }
    NSDictionary *dict = nil;
    if(_listType == FansType){
        if([[ACPUserModel shareModel].uid isEqualToString:dataModel.fans_id]){
            [MBProgressHUD showError:@"自己无法关注自己的哦"];
            sender.enabled = YES;
            return ;
        }
        dict = @{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":AddConcerned,
                 @"paramData":@{@"fans_id":@([ACPUserModel shareModel].uid.integerValue),
                                @"user_id":dataModel.fans_id}
                 };
    }else{
        if([[ACPUserModel shareModel].uid isEqualToString:dataModel.user_id]){
            [MBProgressHUD showError:@"自己无法关注自己的哦"];
            sender.enabled = YES;
            return ;
        }
        dict = @{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":AddConcerned,
                 @"paramData":@{@"fans_id":@([ACPUserModel shareModel].uid.integerValue),
                                @"user_id":dataModel.user_id}
                 };
    }
    
    NSLog(@"%@",BaseUrl(AddConcerned));
    
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(AddConcerned) parameters:dict success:^(id responseObject) {
        sender.enabled = YES;
        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"关注成功"];
            [self getData];
        }else{
            [MBProgressHUD showError:@"关注失败"];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络错误"];
    }];
}

-(void)cancelAttentionActionWithDataModel:(ACPConcernedDataModel *)dataModel sender:(UIButton *)sender{
    if(![ACPUserModel shareModel].isLogin){
        [self loginAction];
        sender.enabled = YES;
        return;
    }
    NSDictionary *dict = nil;
    NSLog(@"%@",BaseUrl(RemoveConcerned));
    if(_listType == FansType){
        dict = @{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":RemoveConcerned,
                 @"paramData":@{@"fans_id":@([ACPUserModel shareModel].uid.integerValue),
                                @"user_id":dataModel.fans_id}
                 };
    }else{
        dict = @{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":RemoveConcerned,
                 @"paramData":@{@"fans_id":@([ACPUserModel shareModel].uid.integerValue),
                                @"user_id":dataModel.user_id}
                 };
    }
    
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(RemoveConcerned) parameters:dict success:^(id responseObject) {
        sender.enabled = YES;
        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"取消关注成功"];
            [self getData];
        }else{
            [MBProgressHUD showError:@"取消关注失败"];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        sender.enabled = YES;
    }];
}

-(void)loginAction{
    ACPLoginViewController *loginVC = [ACPLoginViewController new];
    loginVC.popVC = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPConcernedDataModel *dataModel = _dataSource[indexPath.row];
    ACPBBSPersonalViewController *BBSPersonalVC = [ACPBBSPersonalViewController new];
    if(_listType == FansType){
        BBSPersonalVC.userId = dataModel.fans_id;
    }else{
        BBSPersonalVC.userId = dataModel.user_id;
    }
    BBSPersonalVC.userImageUrl = dataModel.user_image_url;
    BBSPersonalVC.userName = dataModel.user_name;
    BBSPersonalVC.introduction = dataModel.user_brief_introduction;
    [self.navigationController pushViewController:BBSPersonalVC animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPConcernedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fansConcernedCell" forIndexPath:indexPath];
    ACPConcernedDataModel *dataModel = _dataSource[indexPath.row];
    cell.fansDataModel = dataModel;
    cell.didClickAttentionActionBtnBlock = ^(UIButton *sender){
        sender.enabled = NO;
        if(sender.selected){
            [self cancelAttentionActionWithDataModel:dataModel sender:sender];
        }else{
            [self didAttentionActionWithDataModel:dataModel sender:sender];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
