//
//  ACPModifyPasswordController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPModifyPasswordController.h"
#import "ACPTextFieldCell.h"

#define RegisterTextTag 110

@interface ACPModifyPasswordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataArr;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ACPModifyPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = GlobalLightGreyColor;
    [self customBackBtn];
    [self customTitleWith:@"修改密码"];
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
    [tableView registerClass:[ACPTextFieldCell class] forCellReuseIdentifier:@"modifyPasswordCell"];
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
    tipInfor.text = @"* 密码修改成功后,请牢记您的新密码,不要将密码透漏给其他人";
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
    DTextField *oldPasswordText  = (DTextField *)[self.view viewWithTag:RegisterTextTag];
    DTextField *newPassWordText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 1];
    DTextField *rePassWordText   = (DTextField *)[self.view viewWithTag:RegisterTextTag + 2];
    
    if (![oldPasswordText.text isNotNil]) {
        oldPasswordText.promptText = @"请输入原始密码";
        return;
    }
    else if (![newPassWordText.text isNotNil]) {
        newPassWordText.promptText = @"请输入新密码";
        return;
    }else if (![rePassWordText.text isNotNil]){
        rePassWordText.promptText = @"请确认密码";
        return;
    }
    
    if([newPassWordText.text isEqualToString:oldPasswordText.text]){
        
        newPassWordText.promptText = @"新旧密码不能一致";
        return;
    }
    
    if(![newPassWordText.text isEqualToString:rePassWordText.text]){
        
        newPassWordText.promptText = @"两次密码输入不一致";
        return;
    }
    
    NSLog(@"%@",BaseUrl(ModifyPassword));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":ModifyPassword,
                           @"paramData":@{@"user_id":[ACPUserModel shareModel].uid,
                                          @"user_cipher":newPassWordText.text,
                                          @"user_old_cipher":oldPasswordText.text,
                                          }
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(ModifyPassword) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"修改成功"];
        }else if ([responseObject[@"code"] isEqualToString:@"230003"]){
            [MBProgressHUD showError:@"原密码不正确"];
        }else{
            [MBProgressHUD showError:@"修改失败"];
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"修改失败"];
    }];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ACPTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"modifyPasswordCell"];
    cell.textField.tag = RegisterTextTag + indexPath.row;
    cell.textField.delegate = self;
    cell.title = self.dataArr[indexPath.row][@"title"];
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
        
        //以后可能加图标 保留字典
        _dataArr = @[@{@"title":@"原始密码",@"image":@""},
                     @{@"title":@"新密码",@"image":@""},
                     @{@"title":@"确认密码",@"image":@""}];
    }
    return _dataArr;
}



@end
