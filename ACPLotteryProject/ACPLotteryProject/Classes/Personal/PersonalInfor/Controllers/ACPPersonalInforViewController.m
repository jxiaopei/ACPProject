//
//  ACPPersonalInforViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPPersonalInforViewController.h"
#import "ACPUserImageInforCell.h"
#import "ACPGeneralTableViewCell.h"
#import "ImagePickerManager.h"
#import "CommentManager.h"

#define kAnimationDuration 0.2

typedef NS_ENUM(NSInteger, ACPModifyInforType) {
    ACPModifyGenderInforType = 0,
    ACPModifyIntroductionInforType,
};

@interface ACPPersonalInforViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UIView *markView;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UILabel *introductionLabel;
@property(nonatomic,strong)UIImageView *headIcon;

@property(nonatomic,assign)BOOL isIntroductionViewInit;
@property(nonatomic,copy)NSString *introduceStr;
@property(nonatomic,copy)void (^motifyInforComplateBlock)();

@end

@implementation ACPPersonalInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTitleWith:@"个人信息"];
    [self customBackBtn];
    _selectedIndex = 0;
    _titleArr = @[@"头像",@"昵称",@"简介",@"性别"];
    _dataArr = @[@"男",@"女",@"保密"];
    [self setupTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:BaseUrl([ACPUserModel shareModel].imageUrl)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
}



-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.bounces = NO;
    tableView.rowHeight = 50;
    [tableView registerClass:[ACPUserImageInforCell class] forCellReuseIdentifier:@"imageInforCell"];
    [tableView registerClass:[ACPGeneralTableViewCell class] forCellReuseIdentifier:@"inforCell"];
    tableView.tableFooterView = [UIView new];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
       [[ImagePickerManager shareManager]initImagePickerViewAndHandleTheImagePathBlock:^(NSString *imagePath) {
           [self uploadImageWithImagePath:imagePath];
       }];
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        if(_isIntroductionViewInit){
            return;
        }
        [self initIntroduceView];
    }else if (indexPath.row == 3){
        [self initPickView];
    }
}

-(void)uploadImageWithImagePath:(NSString *)imagePath{
    
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    NSString *baseStr =  [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
     NSLog(@"%@",BaseUrl(UploadPerImage));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":UploadPerImage,
                           @"paramData":@{@"user_id": [NSNumber numberWithInt: [[ACPUserModel shareModel].uid intValue]],
                                          @"user_image" : baseStr,
                                          @"token": [ACPUserModel shareModel].currentToken}
                           };
    [[ACPNetworkTool getInstance] postImageDataToServiceWithUrl:BaseUrl(UploadPerImage) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [ACPUserModel shareModel].imageUrl = responseObject[@"data"][@"user_image_url"];
             _headIcon.image = [UIImage imageWithContentsOfFile:imagePath];
            [MBProgressHUD showSuccess:@"上传成功"];
        }else{
            [MBProgressHUD showError:@"上传失败"];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"上传失败"];
    }];
    
}


-(void)initIntroduceView{
    _isIntroductionViewInit = YES;
    [[CommentManager shareManager] initWithTitle:@"编写简介" placeHolder:@"请输入简介" commentComplateBlock:^(UITextView *textView, UIView *markView) {
        _introduceStr = textView.text;
        [self modifyPersonalInforWithInforType:ACPModifyIntroductionInforType];
        self.motifyInforComplateBlock = ^{
           [textView endEditing:YES];
        };
    } doNothingBlock:^{
        
    }];
}

-(void)publishIntroduction{
    
    [self modifyPersonalInforWithInforType:ACPModifyIntroductionInforType];
}

-(void)initPickView{
    UIView *markView = [UIView new];
    _markView = markView;
    markView.backgroundColor = GlobalMarkViewColor;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickCancelBtn:)];
    [markView addGestureRecognizer:tap];
    [self.view addSubview:markView];
    markView.frame = self.view.bounds;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT -240 , SCREENWIDTH, 240)];
    titleView.backgroundColor = [UIColor whiteColor];
    [markView addSubview:titleView];
    
    UIPickerView *datePick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    datePick.backgroundColor = [UIColor whiteColor];
    datePick.delegate = self;
    datePick.dataSource = self;
    [titleView addSubview:datePick];
    
    UIButton *cancelBtn = [UIButton new];
    [titleView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    [cancelBtn setTitle:@"取消" forState: UIControlStateNormal];
    [cancelBtn setTitleColor:GlobalRedColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *comfirmBtn = [UIButton new];
    [titleView addSubview:comfirmBtn];
    [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);;
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    [comfirmBtn setTitle:@"确定" forState: UIControlStateNormal];
    [comfirmBtn setTitleColor:GlobalRedColor forState:UIControlStateNormal];
    [comfirmBtn addTarget:self action:@selector(didClickComfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)didClickCancelBtn:(UIButton *)sender{
    [_markView removeFromSuperview];
}

-(void)didClickComfirmBtn:(UIButton *)sender{
    NSLog(@"%zd",_selectedIndex);
    [self modifyPersonalInforWithInforType:ACPModifyGenderInforType];
}

-(void)modifyPersonalInforWithInforType:(ACPModifyInforType)inforType{
    NSLog(@"%@",BaseUrl(ModifyPerInfor));
    
    if(![[ACPUserModel shareModel].uid isNotNil]){
        return;
    }
    
    NSNumber *uid = [NSNumber numberWithInteger: [[ACPUserModel shareModel].uid integerValue]];
    
    NSMutableDictionary *paramData = [NSMutableDictionary dictionary];
    
    if(inforType == ACPModifyGenderInforType){
        [paramData setValue:uid forKey:@"id"];
        [paramData setValue:_dataArr[_selectedIndex] forKey:@"user_gender"];
        [paramData setValue:[ACPUserModel shareModel].introduction forKey:@"user_brief_introduction"];
    }else if (inforType == ACPModifyIntroductionInforType){
        [paramData setValue:uid forKey:@"id"];
        [paramData setValue:[ACPUserModel shareModel].gender forKey:@"user_gender"];
        [paramData setValue:_introductionLabel.text forKey:@"user_brief_introduction"];
    }
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":ModifyPerInfor,
                           @"paramData":paramData
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(ModifyPerInfor) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            
            if(inforType == ACPModifyGenderInforType){
               _genderLabel.text = _dataArr[_selectedIndex];
                [ACPUserModel shareModel].gender = _dataArr[_selectedIndex];
            }else if (inforType == ACPModifyIntroductionInforType){
                _introductionLabel.text = _introduceStr;
               [ACPUserModel shareModel].introduction = _introductionLabel.text;
                self.motifyInforComplateBlock();
            }
            [MBProgressHUD showSuccess:@"修改成功"];
        }else{
            self.motifyInforComplateBlock();
            [MBProgressHUD showError:@"修改失败"];
        }
    } fail:^(NSError *error) {
        self.motifyInforComplateBlock();
        [MBProgressHUD showError:@"修改失败"];
    }];
    [_markView removeFromSuperview];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  _dataArr[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _selectedIndex = row;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        ACPUserImageInforCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageInforCell" forIndexPath:indexPath];
        cell.titleLabel.text = _titleArr[indexPath.row];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl([ACPUserModel shareModel].imageUrl)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        _headIcon = cell.iconView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        ACPGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inforCell" forIndexPath:indexPath];
        cell.titleLabel.text = _titleArr [indexPath.row];
        if(indexPath.row == 1){
            cell.detailLabel.text = [ACPUserModel shareModel].userAccount;
        }else if(indexPath.row == 2){
          cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
            _introductionLabel = cell.detailLabel;
            cell.detailLabel.text = [ACPUserModel shareModel].introduction;
        }else if (indexPath.row == 3){
          cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
            _genderLabel = cell.detailLabel;
            cell.detailLabel.text = [ACPUserModel shareModel].gender;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 110;
    }
    return 50;
}

@end
