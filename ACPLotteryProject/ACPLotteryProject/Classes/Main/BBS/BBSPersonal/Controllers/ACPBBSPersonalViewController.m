//
//  ACPBBSPersonalViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/20.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBBSPersonalViewController.h"
#import "ACPConcernedDataModel.h"
#import "ACPBBSListDataModel.h"
#import "ACPBBSPersonalTableViewCell.h"
#import "ACPLoginViewController.h"
#import "ACPFansConListViewController.h"
#import "ACPBBSDetailViewController.h"
#import "ACPPublishBSSViewController.h"
#import "ACPBBSImageCollectionViewCell.h"
#import "ImagePickerManager.h"
#import "CommentManager.h"


@interface ACPBBSPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,SDPhotoBrowserDelegate>

@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <ACPBBSListDataModel *>*dataSource;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *introductionLabel;
@property(nonatomic,strong)UIButton *attentionBtn;
@property(nonatomic,strong)UILabel *publishCount;
@property(nonatomic,strong)UILabel *fansCount;
@property(nonatomic,strong)UILabel *attentionCount;
@property(nonatomic,strong)ACPConcernedDataModel *dataModel;

@property(nonatomic,copy)NSString *Id;

@property(nonatomic,strong)NSMutableArray *browserImageArr;
@property(nonatomic,strong)NSMutableArray *browserImgUrlArr;

@end

@implementation ACPBBSPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    [self customBackBtn];
    [self setupNavigationTitleView];
    [self setupUI];
    [self setupTableView];
    
}

-(void)setupNavigationTitleView{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0 , 0, 50, 40);
    self.navigationItem.titleView = view;
    UIButton *btn = [UIButton new];
    [view addSubview:btn];
    btn.frame = CGRectMake(0 , 0, 50, 40);
    [btn addTarget:self action:@selector(didClickHeaderView:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getPersonalData];
    [self getData];
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
    
    self.view.backgroundColor = GlobalLightGreyColor;
    UIImageView *backImageView = [UIImageView new];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"BBS个人背景图"];
    
    UIImageView *iconView = [UIImageView new];
    [self.view addSubview:iconView];
    _iconView = iconView;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30);
        make.width.height.mas_equalTo(50);
    }];
    [iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(_userImageUrl)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 25;
    iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickHeaderView:)];
    [iconView addGestureRecognizer:tap];
    
    UILabel *nameLabel = [UILabel new];
    [self.view addSubview:nameLabel];
    _nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = _userName;
    
    UILabel *introductionLabel = [UILabel new];
    [self.view addSubview:introductionLabel];
    _introductionLabel = introductionLabel;
    [introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(0);
    }];
    introductionLabel.font = [UIFont systemFontOfSize:13];
    introductionLabel.textColor = [UIColor whiteColor];
    introductionLabel.text = _introduction.length > 0 ? _introduction : @"";
    
    UIButton *attentionBtn = [UIButton new];
    [self.view addSubview:attentionBtn];
    _attentionBtn = attentionBtn;
    [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(introductionLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
        make.height.width.mas_equalTo(20);
    }];
    [attentionBtn setImage:[UIImage imageNamed:@"添加好友"] forState:UIControlStateNormal];
    [attentionBtn addTarget:self action:@selector(didClickAttentionActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *titleView = [UIView new];
    [self.view addSubview:titleView];
    titleView.backgroundColor = [UIColor whiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(attentionBtn.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(70);
    }];
    
    NSArray *titleArr = @[@"发布",@"粉丝",@"关注"];
    CGFloat btnW = (SCREENWIDTH - 60)/3;
    for(int j = 0; j < titleArr.count - 1; j++){
        UIView *verLine = [UIView new];
        [titleView addSubview:verLine];
        verLine.frame = CGRectMake(10 + btnW + 4 + j * (btnW + 10), 25, 2, 20);
        verLine.backgroundColor = GlobalLightGreyColor;
    }
    
    for(int i = 0;i < titleArr.count;i++){
       
        UILabel *countLabel = [UILabel new];
        [titleView addSubview:countLabel];
        countLabel.frame = CGRectMake(10 + i * (btnW + 10), 15, btnW, 20);
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.text = @"0";
        countLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel *titleLabel = [UILabel new];
        [titleView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(10 + i * (btnW + 10), 40, btnW, 20);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.text = titleArr[i];
        titleLabel.font = [UIFont systemFontOfSize:14];
        
        UIButton *btn = [UIButton new];
        [titleView addSubview:btn];
        btn.frame = CGRectMake(10 + i *( btnW + 10), 10, btnW, 50);
        if(i == 0){
            _publishCount = countLabel;
            [btn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 1){
            _fansCount = countLabel;
            [btn addTarget:self action:@selector(didClickFansBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            _attentionCount = countLabel;
            [btn addTarget:self action:@selector(didClickAttentionBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    if([_userId isEqualToString:[ACPUserModel shareModel].uid]){
        _attentionBtn.hidden = YES;
    }else{
        _attentionBtn.hidden = NO;
    }

}

-(void)didClickAttentionActionBtn:(UIButton *)sender{
    
    if(![ACPUserModel shareModel].isLogin){
        ACPLoginViewController *loginVC = [ACPLoginViewController new];
        loginVC.popVC = self;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    sender.enabled = NO;
    NSLog(@"%@",BaseUrl(AddConcerned));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":AddConcerned,
                           @"paramData":@{@"fans_id":@([ACPUserModel shareModel].uid.integerValue),
                                          @"user_id":_userId}
                           };
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(AddConcerned) parameters:dict success:^(id responseObject) {
        sender.enabled = YES;
      
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"关注成功"];
            [self getPersonalData];
        }else{
            [MBProgressHUD showError:@"关注失败"];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络错误"];
    }];
    
}

-(void)didClickPublishBtn:(UIButton *)sender{
   if(![_userId isEqualToString:[ACPUserModel shareModel].uid]){
       [MBProgressHUD showError:@"只有本人的页面才能发布哦"];
       return;
   }
    ACPPublishBSSViewController *publishBSSVC = [ACPPublishBSSViewController new];
    [self.navigationController pushViewController:publishBSSVC animated:YES];
}

-(void)didClickFansBtn:(UIButton *)sender{
    ACPFansConListViewController *fansConListVC = [ACPFansConListViewController new];
    fansConListVC.listType = FansType;
    fansConListVC.userId = _userId;
    [self.navigationController pushViewController:fansConListVC animated:YES];
}

-(void)didClickAttentionBtn:(UIButton *)sender{
    ACPFansConListViewController *fansConListVC = [ACPFansConListViewController new];
    fansConListVC.listType = ConcernedType;
    fansConListVC.userId = _userId;
    [self.navigationController pushViewController:fansConListVC animated:YES];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(PerCommunityList));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":PerCommunityList,
                           @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                           @"pageSize":@5 ,
                                           @"user_me_id":@([ACPUserModel shareModel].uid.integerValue),
                                           @"user_id":@(_userId.integerValue)}
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(PerCommunityList) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                _dataSource = [ACPBBSListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr = [ACPBBSListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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

-(void)getPersonalData{
    NSLog(@"%@",BaseUrl(BBSPersonal));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":BBSPersonal,
                           @"paramData":@{
                                        @"user_me_id":@([ACPUserModel shareModel].uid.integerValue),
                                        @"user_id":@(_userId.integerValue)}
                           };
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(BBSPersonal) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            _dataModel = [ACPConcernedDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            _publishCount.text = _dataModel.count_community;
            _fansCount.text = _dataModel.count_fans;
            _attentionCount.text = _dataModel.count_concerned;
            _introductionLabel.text = _dataModel.user_brief_introduction;
            _nameLabel.text = _dataModel.user_name;
            [_iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(_dataModel.user_image_url)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            if([_userId isEqualToString:[ACPUserModel shareModel].uid] || _dataModel.user_concerned == 1){
                _attentionBtn.hidden = YES;
            }else{
                _attentionBtn.hidden = NO;
            }
        }else{
            
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        
    }];
}

-(void)didClickHeaderView:(UITapGestureRecognizer *)tap{

    [[ImagePickerManager shareManager]initImagePickerViewAndHandleTheImagePathBlock:^(NSString *imagePath) {
        [self uploadImageWithImagePath:imagePath];
    }];
}


-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.frame = CGRectMake(0, 250, SCREENWIDTH, SCREENHEIGHT - 250);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ACPBBSPersonalTableViewCell class] forCellReuseIdentifier:@"BBSPersonalCell"];
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
            _iconView.image = [UIImage imageWithContentsOfFile:imagePath];
            [MBProgressHUD showSuccess:@"上传成功"];
        }else{
            [MBProgressHUD showError:@"上传失败"];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"上传失败"];
    }];
    
}

-(void)delectPublishWithIdStr:(NSString *)Id sender:(UIButton *)sender{
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除帖子吗?" message:@"删除后将无法找回" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *comfirtAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@",BaseUrl(DelectPublish));
        NSDictionary *dict = @{
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                               @"uri":DelectPublish,
                               @"paramData":@{@"user_id": [NSNumber numberWithInt: [[ACPUserModel shareModel].uid intValue]],
                                              @"id" : @(Id.integerValue),
                                              }
                               };
        [[ACPNetworkTool getInstance] postImageDataToServiceWithUrl:BaseUrl(DelectPublish) parameters:dict success:^(id responseObject) {
            sender.enabled = YES;
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
                [MBProgressHUD showSuccess:@"删除成功"];
                [self getData];
            }else{
                [MBProgressHUD showError:@"删除失败"];
            }
        } fail:^(NSError *error) {
            sender.enabled = YES;
            [MBProgressHUD showError:@"网络错误"];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:comfirtAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)likeActionWithIdStr:(NSString *)Id sender:(UIButton *)sender{
    NSLog(@"%@",BaseUrl(LikePublish));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":LikePublish,
                           @"paramData":@{@"user_id": [NSNumber numberWithInt: [[ACPUserModel shareModel].uid intValue]],
                                          @"community_id" : @(Id.integerValue),
                                          }
                           };
    [[ACPNetworkTool getInstance] postImageDataToServiceWithUrl:BaseUrl(LikePublish) parameters:dict success:^(id responseObject) {
        sender.enabled = YES;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(sender.selected){
              [MBProgressHUD showSuccess:@"取消关注成功"];
            }else{
              [MBProgressHUD showSuccess:@"关注帖子成功"];
            }
            
            [self getData];
        }else{
            [MBProgressHUD showError:@"操作失败"];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络错误"];
    }];
}

-(void)collectActionWithIdStr:(NSString *)Id sender:(UIButton *)sender{
    NSLog(@"%@",BaseUrl(CollectPublish));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":CollectPublish,
                           @"paramData":@{@"user_id": [NSNumber numberWithInt: [[ACPUserModel shareModel].uid intValue]],
                                          @"community_id" : @(Id.integerValue),
                                          }
                           };
    [[ACPNetworkTool getInstance] postImageDataToServiceWithUrl:BaseUrl(CollectPublish) parameters:dict success:^(id responseObject) {
        sender.enabled = YES;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(sender.selected){
                [MBProgressHUD showSuccess:@"取消收藏成功"];
            }else{
                [MBProgressHUD showSuccess:@"收藏帖子成功"];
            }
            
            [self getData];
        }else{
            [MBProgressHUD showError:@"操作失败"];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络错误"];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPBBSDetailViewController *BBSDetailVC = [ACPBBSDetailViewController new];
    ACPBBSListDataModel *model = _dataSource [indexPath.row];
    BBSDetailVC.userId = model.user_id;
    BBSDetailVC.Id = model.Id;
    [self.navigationController pushViewController:BBSDetailVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACPBBSPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSPersonalCell" forIndexPath:indexPath];
    ACPBBSListDataModel *dataModel = self.dataSource[indexPath.row];
    cell.dataModel = dataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak __typeof__(cell) weakCell = cell;
    cell.didClickCollectionViewCellBlock = ^(NSInteger index){
        NSArray *cellArr = weakCell.collectionView.visibleCells;
        [self.browserImageArr removeAllObjects];;
        for(int i = 0;i < cellArr.count;i++){
            ACPBBSImageCollectionViewCell *imageCell = cellArr[i];
            [_browserImageArr addObject:imageCell.imageView.image];
        }
        NSArray *urlArr = [dataModel.release_image_url componentsSeparatedByString:@","];
        self.browserImgUrlArr = urlArr.copy;
        SDPhotoBrowser *browser = [SDPhotoBrowser new];
        browser.sourceImagesContainerView = weakCell.collectionView;
        browser.imageCount = cellArr.count;
        browser.currentImageIndex = index;//当前需要展示图片的index
        browser.delegate = self;
        [browser show];
    };
    cell.didClickDelectBtnBlock = ^(UIButton *sender) {
        sender.enabled = NO;
        [self delectPublishWithIdStr:dataModel.Id sender:sender];
    };
    cell.didClickLikeBtnBlock = ^(UIButton *sender){
        sender.enabled = NO;
        [self likeActionWithIdStr:dataModel.Id sender:sender];
    };
    cell.didClickCommentBtnBlock = ^{
        if(![ACPUserModel shareModel].isLogin){
            ACPLoginViewController *loginVC = [ACPLoginViewController new];
            loginVC.popVC = self;
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.Id = dataModel.Id;

        [[CommentManager shareManager] initWithTitle:@"" placeHolder:@"请输入评论内容" commentComplateBlock:^(UITextView *textView, UIView *markView){
            if(![textView.text isNotNil]){
                [MBProgressHUD showError:@"评论内容不能为空"];
                return;
            }
            
            NSLog(@"%@",BaseUrl(AddComment));
            
            NSDictionary *dict = @{
                                   @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                                   @"uri":AddComment,
                                   @"paramData":@{@"user_id": [NSNumber numberWithInt: [[ACPUserModel shareModel].uid intValue]],
                                                  @"b_community_id" : @(_Id.integerValue),
                                                  @"return_content" : textView.text,
                                                  }
                                   };
            [[ACPNetworkTool getInstance] postImageDataToServiceWithUrl:BaseUrl(AddComment) parameters:dict success:^(id responseObject) {
             
                if([responseObject[@"code"] isEqualToString:@"0000"])
                {
                    [MBProgressHUD showSuccess:@"评论成功"];
                    [self getData];
                }else{
                    [MBProgressHUD showError:@"操作失败"];
                }
                [textView endEditing:YES];
            } fail:^(NSError *error) {
              
                [MBProgressHUD showError:@"网络错误"];
                [textView endEditing:YES];
            }];
        } doNothingBlock:^{
           
        }];

    };
    cell.didClickCollectBtnBlock = ^(UIButton *sender) {
        sender.enabled = NO;
        [self collectActionWithIdStr:dataModel.Id sender:sender];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACPBBSListDataModel *model = _dataSource [indexPath.row];
    return model.rowHeight + 20;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return self.browserImageArr[index];
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return [NSURL URLWithString:BaseUrl(self.browserImgUrlArr[index])];
}

-(NSMutableArray *)browserImageArr{
    if(_browserImageArr == nil){
        _browserImageArr = [NSMutableArray array];
    }
    return _browserImageArr;
}

-(NSMutableArray *)browserImgUrlArr{
    if(_browserImgUrlArr == nil){
        _browserImgUrlArr = [NSMutableArray array];
    }
    return _browserImgUrlArr;
}

@end
