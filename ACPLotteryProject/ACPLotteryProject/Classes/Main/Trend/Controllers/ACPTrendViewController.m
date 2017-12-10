//
//  ACPTrendViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/3.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPTrendViewController.h"
#import "ACPTrendTitleTableViewCell.h"
#import "ACPTrendDataModel.h"
#import "ACPTrendListTableViewCell.h"

@interface ACPTrendViewController ()<UITableViewDelegate,UITableViewDataSource>

//typeId
/*   PK10      1
     快乐10     2
     广州十选五  3
     北京快乐8   4
     幸运飞艇    5
     重庆时时彩  6
     天津时时彩  7
     新疆时时彩  8
     江西11选5  9
     江苏快3    10
*/

@property(nonatomic,strong)UITableView *titleTableView;
@property(nonatomic,strong)UIView *markView;
@property(nonatomic,assign)BOOL isShowView;
@property(nonatomic,assign)NSInteger selectedNum;
@property(nonatomic,strong)UIButton *navSelectBtn;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)NSArray <ACPTrendDataModel *>*dataSource;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)NSArray *menuTitleArr;
@property(nonatomic,strong)UIView *menuView;

@end

@implementation ACPTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedNum = 0;
    _isShowView = YES;
    [self customBackBtn];
    [self setupTitleView];
    _titleLabel.text = _lotteryName;
    for(int i = 0; i < _titleArr.count;i++){
        ACPMainPageLotteryDataModel *model = _titleArr[i];
        if([model.lottery_name isEqualToString: _lotteryName]){
            _selectedNum = i;
        }
    }
    [self setupTopView];
    [self setupTableView];
    [self getDataWithLotteryId:_lotteryId];
    [self getTitleData];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.frame = CGRectMake(0, 80, SCREENWIDTH, SCREENHEIGHT- 64 - 80);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.tag = 100;
    [tableView registerClass:[ACPTrendListTableViewCell class] forCellReuseIdentifier:@"trendListCell"];
    _mainTableView = tableView;
}

-(void)getTitleData{
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":LotTrendsList,
                           @"paramData":@{}
                           };
    
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(LotTrendsList) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
             NSArray *titleArr = [ACPMainPageLotteryDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            for(int i = 0; i < titleArr.count;i++){
                ACPMainPageLotteryDataModel *model = titleArr[i];
                if([model.lottery_name isEqualToString: _lotteryName]){
                    _selectedNum = i;
                    _titleArr = titleArr;
                    return ;
                }
            }
            
        }
        [_mainTableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}

-(void)getDataWithLotteryId:(NSString *)Id{
    ACPMainPageLotteryDataModel *model = _titleArr[_selectedNum];
    NSString *lotteryId = [Id isNotNil] ? Id : model.Id;

    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":LotteryHisList,
                           @"paramData":@{@"lottery_type":lotteryId}
                           };
    
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(LotteryHisList) parameters:dict success:^(id responseObject) {
        
//        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            _dataSource = [ACPTrendDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"result_List"]];
            if(_dataSource.count ==0){
                [MBProgressHUD showError:@"暂无数据"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        [_mainTableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}

-(void)setupTopView{
    
    UIView *topView = [UIView new];
    [self.view addSubview:topView];
    topView.frame = CGRectMake(0, 0, SCREENWIDTH, 80);
//    topView.backgroundColor = [UIColor redColor];/
    _topView = topView;
    NSArray *titleArr = nil;
    
    switch (_selectedNum) {
        case 0://pk10
            titleArr = @[@{@"title":@"号码",@"subTitle":@"开奖号码"},@{@"title":@"总和",@"subTitle":@"冠亚军和"},@{@"title":@"1~5龙虎",@"subTitle":@"1~5龙虎"}];
            break;
        case 1://快乐十分
            titleArr = @[@{@"title":@"号码",@"subTitle":@"开奖号码"},@{@"title":@"总和",@"subTitle":@"总和"},@{@"title":@"1~4龙虎",@"subTitle":@"1~4龙虎"}];
            break;
        case 2:
        case 8://11选5
            titleArr = @[@{@"title":@"号码",@"subTitle":@"开奖号码"},@{@"title":@"总和",@"subTitle":@"总和"},@{@"title":@"龙虎",@"subTitle":@"龙虎"},@{@"title":@"三星",@"subTitle":@[@"前三",@"中三",@"后三"]}];
            break;
        case 3://快乐8
            titleArr = @[@{@"title":@"号码",@"subTitle":@"开奖号码"},@{@"title":@"总和",@"subTitle":@[@"飞盘号",@"总和",@"单/双",@"大/小",@"上/下",@"五行"]}];
        case 9: // 快3
            titleArr = @[@{@"title":@"号码",@"subTitle":@"开奖号码"},@{@"title":@"总和",@"subTitle":@"总和"}];
            break;
        case 4:
            titleArr = @[@{@"title":@"号码",@"subTitle":@"开奖号码"},@{@"title":@"总和",@"subTitle":@"冠亚和"},@{@"title":@"1~5龙虎",@"subTitle":@"1~5龙虎"}];
            break;
        case 5:
        case 6:
        case 7:
            titleArr = @[@{@"title":@"号码",@"subTitle":@"开奖号码"},@{@"title":@"总和",@"subTitle":@"总和"},@{@"title":@"龙虎",@"subTitle":@"龙虎"},@{@"title":@"三星",@"subTitle":@[@"前三",@"中三",@"后三"]}];
            break;
        default:
            break;
    }
    
    _menuTitleArr = titleArr;
    
    for(int i = 0; i < titleArr.count; i++){
        
        UIButton *btn = [UIButton new];
        [topView addSubview:btn];
        btn.frame = CGRectMake(SCREENWIDTH/titleArr.count *i, 5, SCREENWIDTH/titleArr.count, 30);
        [btn setTitle:titleArr[i][@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:GlobalRedColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(didClickTopViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        if(i == 0){
            btn.selected = YES;
            self.selectBtn = btn;
        }
    }
    
    UIView *lineView = [UIView new];
    [topView addSubview:lineView];
    lineView.backgroundColor = GlobalLightGreyColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        make.height.mas_equalTo(5);
    }];
    
    [self initMenuViewWithIndex:self.selectBtn.tag];
    
}

-(void)initMenuViewWithIndex:(NSInteger)index{
    UIView *menuView = [UIView new];
    [_topView addSubview:menuView];
    _menuView = menuView;
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
    }];
    
    UILabel *title1 = [UILabel new];
    [menuView addSubview:title1];
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
    }];
    title1.text = @"期数";
    title1.textColor = [UIColor blackColor];
    title1.font = [UIFont systemFontOfSize:13];
    
    UILabel *title2 = [UILabel new];
    [menuView addSubview:title2];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-5);
    }];
    title2.text = @"日期";
    title2.textColor = [UIColor blackColor];
    title2.font = [UIFont systemFontOfSize:13];
    
    UILabel *title3 = [UILabel new];
    [menuView addSubview:title3];
    [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(80);
        make.centerY.mas_equalTo(0);
    }];
    title3.textColor = [UIColor blackColor];
    title3.font = [UIFont systemFontOfSize:13];
    title3.textAlignment = NSTextAlignmentCenter;
    
    if([_menuTitleArr[index][@"subTitle"] isKindOfClass:[NSArray class]]){
        NSString *str = @"";
        for(NSString *title in _menuTitleArr[index][@"subTitle"]){
          str  = [str stringByAppendingString:[NSString stringWithFormat:@"%@  ",title]];
        }
        title3.text =  str;
    }else{
        title3.text = _menuTitleArr[index][@"subTitle"];
    }
    
    UIView *lineView = [UIView new];
    [menuView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    lineView.backgroundColor = [UIColor lightGrayColor];
}

-(void)didClickTopViewBtn:(UIButton *)sender{
    sender.selected = YES;
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    [_menuView removeFromSuperview];
    [self initMenuViewWithIndex:_selectBtn.tag];
    [self.mainTableView reloadData];
}

-(void)setupTitleView{
    
    UIView *titleView = [UIView new];
    titleView.frame = CGRectMake(0, 0, 100, 35);
    
    UIImageView *triangleView = [UIImageView new];
    [titleView addSubview:triangleView];
    [triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.width.mas_equalTo(15);
    }];
    triangleView.image = [UIImage imageNamed:@"箭头下"];
    
    UILabel *titleLabel = [UILabel new];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(triangleView.mas_left).mas_offset(-5);
        make.width.mas_equalTo(80);
    }];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel = titleLabel;
    UIButton *showMoreBtn = [UIButton new];
    [titleView addSubview:showMoreBtn];
    [showMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(0);
        
    }];
    
    [showMoreBtn addTarget:self action:@selector(didClickShowMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleView;

}

-(void)didClickShowMoreBtn:(UIButton *)sender{
    
    _isShowView = !_isShowView;
    
    if(_isShowView == NO){
        
        UITableView *tableView = [UITableView new];
        [self.view addSubview:tableView];
        CGFloat height = self.titleArr.count * 40 > SCREENHEIGHT - 64 ? SCREENHEIGHT - 64 : self.titleArr.count * 40;
        tableView.frame = CGRectMake(0, 0, SCREENWIDTH, height);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 40;
        tableView.tag = 200;
        [tableView registerClass:[ACPTrendTitleTableViewCell class] forCellReuseIdentifier:@"titleCell"];
        _titleTableView = tableView;
        
        UIView *markView = [UIView new];
        [self.view addSubview:markView];
        [markView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(SCREENHEIGHT - 64 - height);
        }];
        markView.backgroundColor = GlobalMarkViewColor;
        _markView = markView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickMaskView)];
        [markView addGestureRecognizer:tap];
    }else{
        [self didClickMaskView];
    }
}

-(void)didClickMaskView{
    
    [_titleTableView removeFromSuperview];
    [_markView removeFromSuperview];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 200){
        [_titleTableView removeFromSuperview];
        [_markView removeFromSuperview];
        [_topView removeFromSuperview];
        _selectedNum = indexPath.row;
        ACPMainPageLotteryDataModel *model = _titleArr[indexPath.row];
        _titleLabel.text = model.lottery_name;
        [self setupTopView];
        [self getDataWithLotteryId:nil];
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 100){
        return _dataSource.count;
    }else{
       return _titleArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 100){
        ACPTrendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trendListCell" forIndexPath:indexPath];
        ACPTrendDataModel *dataModel = _dataSource [indexPath.row];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@期", dataModel.lottery_nper];
        cell.timeLabel.text = [[dataModel.create_time insertStandardTimeFormat] substringToIndex:7];
        if(self.selectBtn.tag == 0){
          cell.numLabel.text = dataModel.lottery_result;
            if(_selectedNum == 3){
                cell.numLabel.numberOfLines = 2;
            }else{
                cell.numLabel.numberOfLines = 1;
            }
        }else if (self.selectBtn.tag == 1){
            if(_selectedNum == 0 || _selectedNum == 2 || _selectedNum == 4 || _selectedNum == 5 || _selectedNum == 6 || _selectedNum == 7 || _selectedNum == 8){
               cell.numLabel.text = [NSString stringWithFormat:@"%@  %@  %@", dataModel.sum,dataModel.size,dataModel.single];
            }else if (_selectedNum == 1){
               cell.numLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@", dataModel.sum,dataModel.size,dataModel.single,dataModel.endSize];
            }else if (_selectedNum == 3){
                cell.numLabel.text = [NSString stringWithFormat:@"%zd  %@  %@  %@  %@  %@",dataModel.fpNumber, dataModel.sum,dataModel.single,dataModel.size,dataModel.up,dataModel.fiveXin];
            }else if(_selectedNum == 9){
                cell.numLabel.text = [NSString stringWithFormat:@"%@  %@", dataModel.sum,dataModel.size];
            }
            
        }else if (self.selectBtn.tag == 2){
            if(_selectedNum == 0 || _selectedNum == 4){
                cell.numLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@  %@",dataModel.lh[0],dataModel.lh[1],dataModel.lh[2],dataModel.lh[3],dataModel.lh[4]];
            }else if (_selectedNum == 1){
                cell.numLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@",dataModel.lh[0],dataModel.lh[1],dataModel.lh[2],dataModel.lh[3]];
            }else if (_selectedNum == 2 || _selectedNum == 5 || _selectedNum == 6 || _selectedNum == 7 || _selectedNum == 8){
                cell.numLabel.text = dataModel.lh[0];
            }
        }else if(self.selectBtn.tag == 3){
            if(_selectedNum == 2 || _selectedNum == 5 || _selectedNum == 6 || _selectedNum == 7 || _selectedNum == 8){
                cell.numLabel.text = [NSString stringWithFormat:@"%@  %@  %@", dataModel.firstThere,dataModel.middleThere,dataModel.laterThere];
            }
            
        }
        
        return cell;
    }
    ACPTrendTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
    ACPMainPageLotteryDataModel * model = _titleArr[indexPath.row];
    cell.titleLabel.text = model.lottery_name;
    return cell;
}

@end
