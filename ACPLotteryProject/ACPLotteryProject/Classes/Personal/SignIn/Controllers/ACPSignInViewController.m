//
//  ACPSignInViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPSignInViewController.h"
#import "ACPSignInCollectionViewCell.h"
#import "ACPSignInDataModel.h"

@interface ACPSignInViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSMutableArray <ACPSignInDataModel *>*signInDataArr;
@property(nonatomic,strong)UICollectionView *dateCollectionView;
@property(nonatomic,assign)NSInteger daysOfMonth;
@property(nonatomic,strong)NSString *currentDayStr;
@property(nonatomic,assign)NSInteger weekday;
@property(nonatomic,strong)UIImageView *signInSuccessView;
@property(nonatomic,strong)UILabel *integralLabel;

@end

@implementation ACPSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:@"签到"];
    self.view.backgroundColor = GlobalLightGreyColor;
    [self setupCollectionView];
    [self getSignInList];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(CheckIntegral));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":CheckIntegral,
                           @"paramData":@{@"user_account" : [ACPUserModel shareModel].userAccount,
                                          }
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(CheckIntegral) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"]){

            NSArray *dataArr = responseObject[@"data"][@"resultData"];
            if(!dataArr.count){
                return ;
            }
            NSString *intergral = [NSString stringWithFormat: @"当前积分:%zd",[responseObject[@"data"][@"resultData"][0][@"user_amount"] integerValue]];
            NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:intergral];
            [colorString addAttribute:NSForegroundColorAttributeName value:GlobalRedColor range:NSMakeRange(5, intergral.length-5)];
            _integralLabel.attributedText = colorString;
           
            
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
    
    
    
}

-(void)getSignInList{
    NSLog(@"%@",BaseUrl(SignInList));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":SignInList,
                           @"paramData":@{@"user_account" : [ACPUserModel shareModel].userAccount,
                                          }
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(SignInList) parameters:dict success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"]){
            [_signInDataArr removeAllObjects];
             _signInDataArr = [ACPSignInDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"resultData"]];
            [_dateCollectionView reloadData];
            [self getData];
        }else{
            
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

-(void)setupCollectionView{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *firstDateStr = [NSString stringWithFormat:@"%@01日",dateStr];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *firstDate = [formatter dateFromString:firstDateStr];
    //获取当前星期几
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay fromDate:firstDate];//kCFCalendarUnitWeekOfYear  | NSCalendarUnitWeekday |
    
    // 本月初得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    _weekday = [comps weekday];
    
    [formatter setDateFormat:@"MM"];
    NSString *monthStr = [formatter stringFromDate:date];
    NSInteger month = monthStr.integerValue;
    
    [formatter setDateFormat:@"dd"];
    _currentDayStr = [formatter stringFromDate:date];
    
    
    dateStr = [dateStr  substringToIndex:3];
    NSInteger year = dateStr.integerValue;
    
    NSInteger daysOfMonth = 0;
    
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            daysOfMonth = 31;
            break;
        case 2:
            if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
                daysOfMonth = 29;
            }else{
                daysOfMonth = 28;
            }
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            daysOfMonth = 30;
            break;
    }
    _daysOfMonth = daysOfMonth;
    
    NSInteger rowNum = (_weekday+_daysOfMonth-1) % 7 ? (_daysOfMonth + _weekday-1)/7  + 1: (_daysOfMonth + _weekday-1)/7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREENWIDTH)/7, 60);
    UICollectionView *dateCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , SCREENWIDTH, 60 * rowNum -5 + 190) collectionViewLayout:layout];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [self.view addSubview:dateCollectionView];
    dateCollectionView.backgroundColor = [UIColor whiteColor];
    _dateCollectionView = dateCollectionView;
    dateCollectionView.pagingEnabled = YES;
    dateCollectionView.delegate = self;
    dateCollectionView.dataSource = self;
    dateCollectionView.scrollEnabled = NO;
    [dateCollectionView registerClass:[ACPSignInCollectionViewCell class] forCellWithReuseIdentifier:@"signInDateCell"];
    [dateCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    
}

-(void)didClickSignInActionBtn:(UIButton *)sender{
    NSLog(@"%@",BaseUrl(SignInAction));
    for(ACPSignInDataModel *model in _signInDataArr)
    {
        NSString *signInStr = [model.create_time substringWithRange:NSMakeRange(8, 2)];
        if(_currentDayStr.integerValue == signInStr.integerValue)
        {
            [MBProgressHUD showError:@"您今天已经签到过了"];
            
            return;
        }
    }
    
  
        NSDictionary *dict = @{
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                               @"uri":SignInAction,
                               @"paramData":@{@"user_account" : [ACPUserModel shareModel].userAccount,
                                              @"mission_id"   : @18,
                                              }
                               };
        [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(SignInAction) parameters:dict success:^(id responseObject) {
            
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
                [self showSuccessView];
                [self getSignInList];
                
            }else{
                [MBProgressHUD showError:@"签到失败"];
            }
        } fail:^(NSError *error) {
            NSLog(@"%@",error.description);
            [MBProgressHUD showError:@"网络错误"];
        }];

}



-(void)showSuccessView{
    UIImageView *signInSuccessView = [UIImageView new];
    signInSuccessView.image = [UIImage imageNamed:@"签到成功显示"];
    [self.view addSubview:signInSuccessView];
    signInSuccessView.frame = CGRectMake(-SCREENWIDTH/2, -SCREENHEIGHT/2, SCREENWIDTH * 2, SCREENHEIGHT * 2);
    signInSuccessView.alpha = 0;
    _signInSuccessView = signInSuccessView;
    signInSuccessView.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSignInSuccessViewByAnimation)];
    [signInSuccessView addGestureRecognizer:tap];
    signInSuccessView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        signInSuccessView.alpha = 1.0;
        signInSuccessView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    }];
}

-(void)removeSignInSuccessViewByAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        _signInSuccessView.alpha = 0.0;
        _signInSuccessView.frame = CGRectMake(-SCREENWIDTH/2, -SCREENHEIGHT/2, SCREENWIDTH * 2, SCREENHEIGHT * 2);;
    }completion:^(BOOL finished) {
        [_signInSuccessView removeFromSuperview];
    }];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"forIndexPath:indexPath];
    
    UIImageView *imageView = [UIImageView new];
    [header addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    imageView.image = [UIImage imageNamed:@"签到横图片"];
    imageView.userInteractionEnabled = YES;
    
    UIView *tipView = [UIView new];
    [imageView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(150);
    }];
    tipView.backgroundColor = GlobalDarkBlueColor;
    tipView.layer.masksToBounds = YES;
    tipView.layer.cornerRadius = 5;
    
    UILabel *intergralLabel = [UILabel new];
    [tipView addSubview:intergralLabel];
    [intergralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    intergralLabel.font = [UIFont systemFontOfSize:14];
    intergralLabel.textColor = [UIColor whiteColor];
    NSString *intergral = @"当前积分:0";
    NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:intergral];
    [colorString addAttribute:NSForegroundColorAttributeName value:GlobalRedColor range:NSMakeRange(5, intergral.length-5)];
    intergralLabel.attributedText = colorString;
    _integralLabel = intergralLabel;
    
    UILabel *earnLabel = [UILabel new];
    [tipView addSubview:earnLabel];
    [earnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    earnLabel.font = [UIFont systemFontOfSize:13];
    earnLabel.textColor = [UIColor whiteColor];
    NSString *earnStr = @"今日签到可获得5积分";
    NSMutableAttributedString *earnColorString = [[NSMutableAttributedString alloc]initWithString:earnStr];
    [earnColorString addAttribute:NSForegroundColorAttributeName value:GlobalRedColor range:NSMakeRange(7, earnStr.length-9)];
    earnLabel.attributedText = earnColorString;
    
    UIButton *signInBtn = [UIButton new];
    [imageView addSubview:signInBtn];
    [signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-30);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    [signInBtn setImage:[UIImage imageNamed:@"签到按钮"] forState:UIControlStateNormal];
    [signInBtn addTarget:self action:@selector(didClickSignInActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [UIView new];
    [header addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    lineView.backgroundColor = GlobalLightGreyColor;
    
    UIView *titleView = [UIView new];
    [header addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.mas_equalTo(0);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    titleLabel.font = [UIFont fontWithName:@"ArialMT"size:18];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *dateStr = [formatter stringFromDate:date];
    titleLabel.text = dateStr;
    titleLabel.textColor = [UIColor blackColor];
    
    NSArray *weekDayStrArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    UIView *weekView = [UIView new];
    [header addSubview:weekView];
    [weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(titleView.mas_bottom);
    }];
    weekView.backgroundColor = GlobalLightGreyColor;
    
    for(int i = 0;i < weekDayStrArr.count;i++){
        
        UILabel *weekdayLab = [UILabel new];
        [weekView addSubview:weekdayLab];
        weekdayLab.frame = CGRectMake(SCREENWIDTH/7 * i, 0, SCREENWIDTH/7, 30);
        weekdayLab.text = weekDayStrArr[i];
        weekdayLab.font = [UIFont systemFontOfSize:13];
        weekdayLab.textColor = [UIColor grayColor];
        weekdayLab.textAlignment = NSTextAlignmentCenter;
        
    }

    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(self.view.frame.size.width, 190);
    }
    else {
        return CGSizeMake(0, 0);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACPSignInCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"signInDateCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSString *dateStr = nil;
    if(indexPath.row < _weekday - 1){
        dateStr = @"";
    }else{
        dateStr = [NSString stringWithFormat:@"%zd",indexPath.row - _weekday + 2];
    }
    [cell.btn setTitle:dateStr forState:UIControlStateNormal];
    cell.btn.selected = NO;
    for(ACPSignInDataModel *model in _signInDataArr)
    {
        NSString *signInStr = [model.create_time substringWithRange:NSMakeRange(8, 2)];
        if(dateStr.integerValue == signInStr.integerValue)
        {
            cell.btn.selected = YES;
        }
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _daysOfMonth + _weekday - 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/7, 60);
}

@end
