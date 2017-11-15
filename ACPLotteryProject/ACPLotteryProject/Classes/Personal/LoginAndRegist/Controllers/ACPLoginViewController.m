//
//  ACPLoginViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPLoginViewController.h"
#import "ACPRegistViewController.h"
#import "ACPLoginTextFieldCell.h"
#import "ACPCustomerServiceController.h"

#define RegisterTextTag 110

@interface ACPLoginViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ACPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self setupRightBtn];
    [self setupUI];
    [self setFoot];

}

-(void)setupRightBtn{
    
    UIButton *serviceBtn = [UIButton new];
    serviceBtn.frame = CGRectMake(0, 0, 80, 25);
    [serviceBtn setTitle:@"客服" forState:UIControlStateNormal];
    [serviceBtn setImage:[UIImage imageNamed:@"客服icon"] forState:UIControlStateNormal];
    serviceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [serviceBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 30, 5, 30)];
    serviceBtn.imageView.contentMode =  UIViewContentModeScaleToFill;
    serviceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [serviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [serviceBtn addTarget:self action:@selector(didClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:serviceBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
}

-(void)didClickRightBtn:(UIButton *)sender{
    
    ACPCustomerServiceController *customerServiceVC = [ACPCustomerServiceController new];
    [self.navigationController pushViewController:customerServiceVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0.0f, 0.0f, SCREENWIDTH, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}


-(void)setupUI{
    
    UIImageView *backImageView = [UIImageView new];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    backImageView.image = [UIImage imageNamed:@"个人页面背景图"];
    
    UIImageView *logoView = [UIImageView new];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    logoView.image = [UIImage imageNamed:@"默认头像"];
    
    UILabel *acpLabel = [UILabel new];
    [self.view addSubview:acpLabel];
    [acpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoView.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(0);
    }];
    acpLabel.font = [UIFont systemFontOfSize:17];
    acpLabel.textColor = [UIColor whiteColor];
    acpLabel.text = @"爱彩票";
    
    UIView *lineView = [UIView new];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-100);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    lineView.hidden = NO;
    lineView.backgroundColor = [UIColor clearColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                            style:UITableViewStyleGrouped];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(acpLabel.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
//        make.bottom.mas_equalTo(lineView.mas_top).mas_offset(-30);
        make.height.mas_equalTo(280);
    }];
    tableView.layer.masksToBounds = YES;
    tableView.layer.cornerRadius = 10;
    tableView.layer.borderWidth = 1;
    tableView.layer.borderColor = [UIColor grayColor].CGColor;
   
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [tableView registerClass:[ACPLoginTextFieldCell class] forCellReuseIdentifier:@"LCTextFieldCell"];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self setData];
}

-(void)setData{
    
    YYCache *cache = [YYCache cacheWithName:CacheKey];
    ACPUserModel *userModel = (ACPUserModel *)[cache objectForKey:UserID];
    if ([userModel.userName isNotNil])
    {
        DTextField *userText  = (DTextField *)[self.view viewWithTag:RegisterTextTag];
        DTextField *pwdText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 1];
        userText.text = userModel.userAccount;
        NSString *password = userModel.password;
        NSData *data = [[NSData alloc] initWithBase64EncodedString:password options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *passwordStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        pwdText.text =  passwordStr;
        NSLog(@"%@,%@",userModel.userName,passwordStr);
        
    }
}

- (void)setFoot {
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 40, 160)];
    
    UIButton *LoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREENWIDTH - 80, 44)];
    LoginBtn.layer.masksToBounds = YES;
    LoginBtn.layer.cornerRadius = 22;
    [LoginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    LoginBtn.backgroundColor = GlobalRedColor;
    [LoginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    LoginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [foot addSubview:LoginBtn];
    
    UILabel *tipLabel = [UILabel new];
    [foot addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-35);
        make.width.mas_equalTo(65);
        make.top.mas_equalTo(LoginBtn.mas_bottom).mas_offset(30);
    }];
    tipLabel.text = @"没有账号?";
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.textAlignment = NSTextAlignmentRight;
    
    UIButton *jumpBtn = [UIButton new];
    [foot addSubview:jumpBtn];
    [jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tipLabel.mas_right);
        make.centerY.mas_equalTo(tipLabel);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(30);
    }];
    [jumpBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [jumpBtn setTitleColor:GlobalRedColor forState:UIControlStateNormal];
    jumpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    jumpBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [jumpBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = foot;
}

- (void)loginAction {
    DTextField *userText  = (DTextField *)[self.view viewWithTag:RegisterTextTag];
    DTextField *pwdText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 1];
    
    
    if (![userText.text isNotNil]) {
        userText.promptText = @"请输入用户名";
        return;
    }
    else if (![pwdText.text isNotNil]) {
        pwdText.promptText = @"请输入密码";
        return;
    }
    
    
    NSLog(@"%@",BaseUrl(UserLogin));
    NSDictionary *loginDict = @{
                                @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                                @"uri":UserLogin,
                                @"paramData":@{@"user_name":userText.text,
                                               @"user_cipher":pwdText.text
                                               }
                                };
    
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(UserLogin) parameters:loginDict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"登录成功"];
            ACPUserModel *userModel = [ACPUserModel shareModel];
            userModel.userName = responseObject[@"data"][@"user_name"];;
            userModel.userAccount = responseObject[@"data"][@"user_account"];
            userModel.phoneNumber = responseObject[@"data"][@"user_phone"];
            userModel.currentToken = responseObject[@"data"][@"token"];
            userModel.uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_id"]];
            userModel.integral = [responseObject[@"data"][@"user_integral"] integerValue];
            userModel.gender = responseObject[@"data"][@"user_gender"];
            userModel.imageUrl = responseObject[@"data"][@"user_image_url"];
            userModel.introduction = responseObject[@"data"][@"user_brief_introduction"];
            userModel.isLogin = YES;
            NSData *data = [pwdText.text dataUsingEncoding:NSUTF8StringEncoding];
            NSString *baseString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            userModel.password = baseString;
            YYCache *cache = [YYCache cacheWithName:CacheKey];
            [cache setObject:userModel forKey:UserID];
            if(self.popVC){
                userModel.isLoginOtherView = YES;
                [self.navigationController popToViewController:self.popVC animated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccessed" object:nil];
        }else if ([responseObject[@"code"] isEqualToString:@"230004"]){
            [MBProgressHUD showError:@"用户名或密码不正确"];
        }else{
            [MBProgressHUD showError:@"登录失败"];
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"登录失败"];
    }];
    
}

- (void)registAction{
    
    NSInteger count = 0;
    for(ACPBaseViewController *vc in self.navigationController.viewControllers){
        
        if( [vc isKindOfClass:[ACPRegistViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        count++;
    }
    if(count == self.navigationController.viewControllers.count){
        ACPRegistViewController *registVC = [ACPRegistViewController new];
        [self.navigationController pushViewController:registVC animated:YES];
    }
    
//    ACPRegistViewController *registVC = [ACPRegistViewController new];
//    registVC.popVC =self.popVC;
//    [self.navigationController pushViewController:registVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACPLoginTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCTextFieldCell"];
    cell.textField.tag = RegisterTextTag + indexPath.row;
    cell.textField.delegate = self;
    cell.dict = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}


- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@{@"title":@"用户名",@"image":@"rigest_account"},
                     @{@"title":@"密码",@"image":@"rigest_password"}];
    }
    return _dataArr;
}


@end
