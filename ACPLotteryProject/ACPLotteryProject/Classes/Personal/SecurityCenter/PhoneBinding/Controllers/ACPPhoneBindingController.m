//
//  ACPPhoneBindingController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPPhoneBindingController.h"
#import "ACPTextFieldCell.h"
#import "ACPUserNameTableViewCell.h"
#import "ACPPhoneCodeCell.h"

#define RegisterTextTag 110

@interface ACPPhoneBindingController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataArr;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,weak)UIButton *requstBtn;

@end

@implementation ACPPhoneBindingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GlobalLightGreyColor;
    _count = 60;
    [self customBackBtn];
    [self customTitleWith:@"手机绑定"];
    [self setupTableView];
    [self setFoot];
    [self setupTipInfor];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.dataSource = self;
    tableView.delegate =self;
//    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = 50;
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [tableView registerClass:[ACPTextFieldCell class] forCellReuseIdentifier:@"idBindingCell"];
    [tableView registerClass:[ACPUserNameTableViewCell class] forCellReuseIdentifier:@"userNameCell"];
    [tableView registerClass:[ACPPhoneCodeCell class] forCellReuseIdentifier:@"phoneCodeCell"];

    tableView.tableFooterView = [UIView new];
}

- (void)setFoot {
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 40, 140)];
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, SCREENWIDTH - 60, 44)];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 22;
    [commitBtn setTitle:@"立即提交" forState:UIControlStateNormal];
    commitBtn.backgroundColor = GlobalRedColor;
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [foot addSubview:commitBtn];
    
    self.tableView.tableFooterView = foot;
}

-(void)setupTipInfor{
    
    UILabel *serviceLabel = [UILabel new];
    [self.view addSubview:serviceLabel];
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    serviceLabel.font = [UIFont systemFontOfSize:13];
    serviceLabel.textColor = [UIColor grayColor];
    serviceLabel.text = @"在线客服";
    
    UIImageView *iconView = [UIImageView new];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(serviceLabel.mas_top).mas_offset(-5);
        make.height.width.mas_equalTo(30);
    }];
    iconView.image = [UIImage imageNamed:@"客服图标"];
    
    UILabel *tipInfor2 = [UILabel new];
    [self.view addSubview:tipInfor2];
    [tipInfor2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(iconView.mas_top).mas_offset(-30);
    }];
    tipInfor2.textColor = [UIColor grayColor];
    tipInfor2.font = [UIFont systemFontOfSize:12];
    tipInfor2.text = @"3.若几分钟后仍未收到验证码,请您重新获取验证码或联系在线客服.";
    tipInfor2.numberOfLines = 2;
    
    UILabel *tipInfor1 = [UILabel new];
    [self.view addSubview:tipInfor1];
    [tipInfor1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(tipInfor2.mas_top).mas_offset(-5);
    }];
    tipInfor1.textColor = [UIColor grayColor];
    tipInfor1.font = [UIFont systemFontOfSize:12];
    tipInfor1.text = @"2.运营商发送短信可能有延迟,请您耐心等待";
    
    UILabel *tipInfor = [UILabel new];
    [self.view addSubview:tipInfor];
    [tipInfor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(tipInfor1.mas_top).mas_offset(-5);
    }];
    tipInfor.textColor = [UIColor grayColor];
    tipInfor.font = [UIFont systemFontOfSize:12];
    tipInfor.text = @"1.忘记密码时,可通过手机短信找回密码";
    
    UILabel *tipTitle = [UILabel new];
    [self.view addSubview:tipTitle];
    [tipTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(tipInfor.mas_top).mas_offset(-8);
    }];
    tipTitle.font = [UIFont systemFontOfSize:12];
    tipTitle.textColor = [UIColor grayColor];
    tipTitle.text = @"温馨提示";
    
}

-(void)commitAction{
    DTextField *phoneText  = (DTextField *)[self.view viewWithTag:RegisterTextTag];
    DTextField *codeText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 1];
    
    if (![phoneText.text isNotNil]) {
        phoneText.promptText = @"请输入手机号码";
        return;
    }
    else if (![codeText.text isNotNil]) {
        codeText.promptText = @"请输入验证码";
        return;
    }
    
    NSLog(@"%@",BaseUrl(IDBinding));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":IDBinding,
                           @"paramData":@{@"user_name":phoneText.text,
                                          @"user_cipher":codeText.text
                                          }
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(IDBinding) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            
            
        }else{
            [MBProgressHUD showError:@"绑定失败"];
        }
        [self resetRequstBtn];
        
    } fail:^(NSError *error) {
        [self resetRequstBtn];
        [MBProgressHUD showError:@"绑定失败"];
    }];

}

-(void)setupTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(beginCount) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)beginCount{
    _count --;
    if(_count < 0){
        [self resetRequstBtn];
        return;
    }
    [_requstBtn setTitle:[NSString stringWithFormat:@"%zds",_count] forState:UIControlStateNormal];
}

-(void)resetRequstBtn{
    [_requstBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.timer invalidate];
    self.timer = nil;
    _count = 60;
    _requstBtn.enabled = YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        
        ACPUserNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userNameCell" forIndexPath:indexPath];
        cell.username = [ACPUserModel shareModel].userName;
        return cell;
    }else if (indexPath.row == 2){
        ACPPhoneCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phoneCodeCell" forIndexPath:indexPath];
         cell.textField.tag = RegisterTextTag +1;
        _requstBtn = cell.requstBtn;
        cell.didClickRequstBtnBlock = ^{
            [self setupTimer];
        };
        return cell;
    }else{
        ACPTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idBindingCell"];
        cell.textField.tag = RegisterTextTag ;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.delegate = self;
        cell.title = self.dataArr[indexPath.row - 1][@"title"];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count + 2;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        
        //以后可能加图标 保留字典
        _dataArr = @[@{@"title":@"手机号码",@"image":@""}];
    }
    return _dataArr;
}

@end
