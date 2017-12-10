//
//  ACPPersonalViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPPersonalViewController.h"
#import "ACPPerEixtTableViewCell.h"
#import "ACPPersonalTableViewCell.h"
#import "ACPLoginViewController.h"
#import "ACPRegistViewController.h"
#import "ACPSignInViewController.h"
#import "ACPIntergralViewController.h"
#import "ACPCustomerServiceController.h"
#import "ACPSecurityCenterController.h"
#import "ACPGeneralViewController.h"
#import "ACPAboutUsViewController.h"
#import "ACPPersonalInforViewController.h"

@interface ACPPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ACPPerEixtTableViewCell *loginBtnCell;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UIButton *inforBtn;
@property(nonatomic,strong)UIButton *signInBtn;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *registBtn;
@property(nonatomic,strong)UILabel *waitLabel;

@end

@implementation ACPPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
//    view.backgroundColor = GlobalRedColor;
    [self.view addSubview:view];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLoginSuccessed) name:@"loginSuccessed" object:nil];
    [self setupTableView];
    if(kDevice_Is_iPhoneX){
        UIView *navigationView = [UIView new];
        navigationView.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
//        navigationView.backgroundColor = GlobalRedColor;
        [self.view addSubview:navigationView];
        UIImageView *imageView = [UIImageView new];
        [navigationView addSubview:imageView];
        imageView.frame = navigationView.bounds;
        imageView.image = [UIImage imageNamed:@"iPhone 头部"];
    }
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    [self.tableView reloadData];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl([ACPUserModel shareModel].imageUrl)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginSuccessed" object:nil];
}

-(void)didLoginSuccessed{
    _loginBtnCell.ishiddenBtn = NO;
    _iconView.hidden = NO;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl([ACPUserModel shareModel].imageUrl)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _userNameLabel.hidden = NO;
    _userNameLabel.text = [ACPUserModel shareModel].userName;
    _inforBtn.hidden = NO;
    _signInBtn.hidden = NO;
    _loginBtn.hidden = YES;
    _registBtn.hidden = YES;
    _waitLabel.hidden = YES;
    [self.tableView reloadData];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
    }];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.estimatedSectionHeaderHeight = 10;
    [tableView registerClass:[ACPPersonalTableViewCell class] forCellReuseIdentifier:@"personalCell"];
    [tableView registerClass:[ACPPerEixtTableViewCell class] forCellReuseIdentifier:@"personalExitCell"];
    NSString *verson = [UIDevice currentDevice].systemVersion;
    if(verson.doubleValue > 10.3){
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = [self setHeadView];
}

-(UIView *)setHeadView{

    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREENWIDTH, 200);
//    header.backgroundColor = GlobalRedColor;
    
    UIImageView *backImageView = [UIImageView new];
    [header addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    NSString *imageStr = kDevice_Is_iPhoneX ? @"iPhone 头部1" : @"个人页面背景图" ;
    backImageView.image = [UIImage imageNamed:imageStr];
    
    UIButton *signInBtn = [UIButton new];
    [header addSubview:signInBtn];
    _signInBtn = signInBtn;
    [signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(40);
        make.height.width.mas_equalTo(30);
    }];
    [signInBtn setImage:[UIImage imageNamed:@"签到"] forState:UIControlStateNormal];
    [signInBtn addTarget:self action:@selector(didClickSignInBtn:) forControlEvents:UIControlEventTouchUpInside];
    signInBtn.hidden = YES;
    
    UIImageView *iconView = [UIImageView new];
    [header addSubview:iconView];
    _iconView = iconView;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.width.height.mas_equalTo(80);
    }];
    iconView.image = [UIImage imageNamed:@"默认头像"];
    iconView.hidden = YES;
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 40;
    
    UILabel *userNameLabel = [UILabel new];
    [header addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(iconView.mas_bottom).mas_offset(10);
    }];
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.text = @"用户名称";
    userNameLabel.font = [UIFont systemFontOfSize:14];
    userNameLabel.hidden = YES;
    
    UIButton *inforBtn = [UIButton new];
    [header addSubview:inforBtn];
    _inforBtn = inforBtn;
    [inforBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30);
        make.height.width.mas_equalTo(120);
    }];
    [inforBtn addTarget:self action:@selector(didClickInforBtn:) forControlEvents:UIControlEventTouchUpInside];
    inforBtn.hidden = YES;
    
    UILabel *waitLabel = [UILabel new];
    [header addSubview:waitLabel];
    _waitLabel = waitLabel;
    [waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(60);
    }];
    waitLabel.font = [UIFont systemFontOfSize:16];
    waitLabel.textColor = [UIColor whiteColor];
    waitLabel.text = @"Hi等你好久了!";
    
    UIButton *loginBtn = [UIButton new];
    [header addSubview:loginBtn];
    _loginBtn = loginBtn;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(waitLabel.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(header.mas_centerX).mas_offset(-90);
    }];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 15;
    loginBtn.layer.borderWidth = 1;
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registBtn = [UIButton new];
    [header addSubview:registBtn];
    _registBtn = registBtn;
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(waitLabel.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(header.mas_centerX).mas_offset(30);
    }];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = 15;
    registBtn.layer.borderWidth = 1;
    registBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [registBtn addTarget:self action:@selector(didClickRegistBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if([ACPUserModel shareModel].isLoginOtherView){
        [self didLoginSuccessed];
    }
    return header;
}

-(void)didClickInforBtn:(UIButton *)sender{
    
    ACPPersonalInforViewController *personalInforVC = [ACPPersonalInforViewController new];
    [self.navigationController pushViewController:personalInforVC animated:YES];
}

-(void)didClickSignInBtn:(UIButton *)sender{
    ACPSignInViewController *signInVC = [ACPSignInViewController new];
    [self.navigationController pushViewController:signInVC animated:YES];
}

-(void)didClickLoginBtn:(UIButton *)sender
{
    ACPLoginViewController *loginVC = [ACPLoginViewController new];
    loginVC.popVC = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)didClickRegistBtn:(UIButton *)sender{
    
    ACPRegistViewController *registVC = [ACPRegistViewController new];
    registVC.popVC = self;
    [self.navigationController pushViewController:registVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        if([ACPUserModel shareModel].isLogin){
            ACPIntergralViewController *intergralVC = [ACPIntergralViewController new];
            [self.navigationController pushViewController:intergralVC animated:YES];
        }else{
            ACPLoginViewController *loginVC = [ACPLoginViewController new];
            loginVC.popVC = self;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            ACPCustomerServiceController *serviceVC = [ACPCustomerServiceController new];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }else if (indexPath.row == 1){
            if([ACPUserModel shareModel].isLogin){
                ACPSecurityCenterController *securityCenterVC = [ACPSecurityCenterController new];
                [self.navigationController pushViewController:securityCenterVC animated:YES];
            }else{
                ACPLoginViewController *loginVC = [ACPLoginViewController new];
                loginVC.popVC = self;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }
    }else if (indexPath.section == 2){
       if (indexPath.row == 0){
            ACPGeneralViewController *generalVC = [ACPGeneralViewController new];
            [self.navigationController pushViewController:generalVC animated:YES];
        }else{
            ACPAboutUsViewController *aboutUsVC = [ACPAboutUsViewController new];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 2 && indexPath.row == 2){
        
        ACPPerEixtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalExitCell" forIndexPath:indexPath];
        _loginBtnCell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ishiddenBtn = YES;
        if([ACPUserModel shareModel].isLoginOtherView || [ACPUserModel shareModel].isLogin)
        {
            cell.ishiddenBtn = NO;
        }
        __weak typeof (cell)weakCell = cell;
        cell.didClickExitBtnBlock = ^{
            if([ACPUserModel shareModel].isLogin)
            {
                ACPUserModel *userModel = [ACPUserModel shareModel];
                userModel.userName = nil;
                userModel.userAccount = nil;
                userModel.phoneNumber = nil;
                userModel.currentToken = nil;
                userModel.uid = nil;
                userModel.integral = 0;
                userModel.introduction = nil;
                userModel.gender = nil;
                userModel.imageUrl = nil;
                userModel.isLogin = NO;
                userModel.isLoginOtherView = NO;
                YYCache *cache = [YYCache cacheWithName:CacheKey];
                [cache setObject:userModel forKey:UserID];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutSuccessed" object:nil];
                _iconView.hidden = YES;
                _userNameLabel.hidden = YES;
                _inforBtn.hidden = YES;
                _signInBtn.hidden = YES;
                _loginBtn.hidden = NO;
                _registBtn.hidden = NO;
                _waitLabel.hidden = NO;
                weakCell.ishiddenBtn = YES;
            }
        };
        return cell;
    }else{
        ACPPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
        NSArray *titleArr = self.titleArr[indexPath.section];
        if(indexPath.section == 0){
            cell.detail = @"查看积分获取情况";
        }
        cell.title = titleArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2 && indexPath.row == 2){
        if([ACPUserModel shareModel].isLogin){
            return 110;
        }else{
            return 0;
        }
    }
    return 45;
}

-(NSArray *)titleArr{
    
    if(_titleArr == nil){
        _titleArr = @[@[@"我的积分"],@[@"联系客服",@"安全中心"],@[@"通用",@"关于我们"]];//@"帮助和反馈",
    }
    return _titleArr;
}


@end
