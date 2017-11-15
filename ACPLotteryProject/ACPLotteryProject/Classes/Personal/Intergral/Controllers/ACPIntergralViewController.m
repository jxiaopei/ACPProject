//
//  ACPIntergralViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPIntergralViewController.h"
#import "ACPIntergralServiceCell.h"
#import "ACPIntegralDetailViewController.h"

@interface ACPIntergralViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *serviceView;
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)UILabel *integralLabel;

@end

@implementation ACPIntergralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:@"积分"];
    _titleArr = @[@"积分明细",@"积分",@"积分商城"];
    [self setupServiceView];
    [self getData];
}

-(void)getData{
    
    NSLog(@"%@",BaseUrl(CheckIntegral));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":CheckIntegral,
                           @"paramData":@{ @"user_account": [ACPUserModel shareModel].userAccount
                                          }
                           };
    NSString *url = BaseUrl(CheckIntegral);
    [[ACPNetworkTool getInstance]postDataWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArr = responseObject[@"data"][@"resultData"];
        if(!dataArr.count){
            return ;
        }
        _integralLabel.text = [NSString stringWithFormat:@"%zd",[responseObject[@"data"][@"resultData"][0][@"user_amount"]integerValue]];
        
    } fail:^(NSError *error) {
        
    }];

}

-(void)setupUI{
    
    UIView *header = [UIView new];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];
    header.backgroundColor = [UIColor grayColor];
    
}

-(void)setupServiceView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH /3, 85);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 160) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.tag = 100;
    collectionView.backgroundColor = [UIColor grayColor];
    _serviceView = collectionView;
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
    [collectionView registerClass:[ACPIntergralServiceCell class] forCellWithReuseIdentifier:@"serviceViewCell"];
    
    UILabel *intergralLabel = [UILabel new];
    [self.view addSubview:intergralLabel];
    [intergralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(120);
    }];
    intergralLabel.textColor = [UIColor whiteColor];
    intergralLabel.font = [UIFont systemFontOfSize:13];
    intergralLabel.text = @"0.00";
    _integralLabel = intergralLabel;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item == 0){
        ACPIntegralDetailViewController *detailVC = [ACPIntegralDetailViewController new];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (indexPath.item == 2){
        [MBProgressHUD showSuccess:@"敬请期待"];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titleArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACPIntergralServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"serviceViewCell" forIndexPath:indexPath];
    cell.iconView.image = [UIImage imageNamed:_titleArr[indexPath.row]] ;
    cell.title.text = _titleArr[indexPath.row];
    return cell;
}

@end
