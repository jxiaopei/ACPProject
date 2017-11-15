//
//  ACPIDBindingViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPIDBindingViewController.h"
#import "ACPTextFieldCell.h"
#import "ACPUserNameTableViewCell.h"

#define RegisterTextTag 110

@interface ACPIDBindingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataArr;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ACPIDBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GlobalLightGreyColor;
    [self customBackBtn];
    [self customTitleWith:@"身份绑定"];
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
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = 50;
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [tableView registerClass:[ACPTextFieldCell class] forCellReuseIdentifier:@"idBindingCell"];
    [tableView registerClass:[ACPUserNameTableViewCell class] forCellReuseIdentifier:@"userNameCell"];
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
    
    UILabel *tipInfor = [UILabel new];
    [self.view addSubview:tipInfor];
    [tipInfor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-40);
    }];
    tipInfor.textColor = [UIColor grayColor];
    tipInfor.font = [UIFont systemFontOfSize:12];
    tipInfor.text = @"* 真实姓名和身份证作为存取款信息的唯一凭证,请填写与身份证相同的信息";
    tipInfor.numberOfLines = 2;
    
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
    DTextField *nameText  = (DTextField *)[self.view viewWithTag:RegisterTextTag];
    DTextField *idNumText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 1];
    
    if (![nameText.text isNotNil]) {
        nameText.promptText = @"请输入真实姓名";
        return;
    }
    else if (![idNumText.text isNotNil]) {
        idNumText.promptText = @"请输入身份证号码";
        return;
    }
    
    NSLog(@"%@",BaseUrl(IDBinding));
    NSDictionary *dict = @{
                                @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                                @"uri":IDBinding,
                                @"paramData":@{@"user_id_card_name":nameText.text,
                                               @"user_id_card":idNumText.text,
                                               @"id":[NSNumber numberWithInteger: [[ACPUserModel shareModel].uid integerValue]]
                                               }
                                };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(IDBinding) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
           [MBProgressHUD showSuccess:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"绑定失败"];
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"绑定失败"];
    }];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        
        ACPUserNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userNameCell" forIndexPath:indexPath];
        cell.username = [ACPUserModel shareModel].userName;
        return cell;
        
    }else{
        ACPTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idBindingCell"];
        cell.textField.tag = RegisterTextTag + indexPath.row - 1;
        cell.textField.delegate = self;
        cell.title = self.dataArr[indexPath.row - 1][@"title"];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count + 1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        
        //以后可能加图标 保留字典
        _dataArr = @[@{@"title":@"真实姓名",@"image":@""},
                     @{@"title":@"身份证号",@"image":@""}];
    }
    return _dataArr;
}


@end
