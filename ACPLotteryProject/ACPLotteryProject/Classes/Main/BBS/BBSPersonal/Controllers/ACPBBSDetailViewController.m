//
//  ACPBBSDetailViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBBSDetailViewController.h"
#import "ACPBBSDetailDataModel.h"
#import "ACPCommentDataModel.h"
#import "ACPCommentTableViewCell.h"
#import "ACPBBSDetailTableViewCell.h"
#import "ACPLoginViewController.h"
#import "ACPBBSPersonalViewController.h"
#import "ACPBBSImageCollectionViewCell.h"
#import "CommentManager.h"

@interface ACPBBSDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDPhotoBrowserDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ACPBBSDetailDataModel *dataModel;
@property(nonatomic,strong)UIButton *collectBtn;
@property(nonatomic,strong)UIButton *likeBtn;

@property(nonatomic,strong)NSMutableArray *browserImageArr;
@property(nonatomic,strong)NSMutableArray *browserImgUrlArr;

@end

@implementation ACPBBSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:@"帖子详情"];
    [self setupTableView];
    [self setBottomView];
    [self getData];
    
}

-(void)getData{
    NSString *userId = [ACPUserModel shareModel].isLogin ? [ACPUserModel shareModel].uid : @"";
    NSLog(@"%@",BaseUrl(BSSDetail));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":BSSDetail,
                           @"paramData":@{
                                   @"id":_Id,
                                   @"user_id":userId,
                                   }
                           };
    [[ACPNetworkTool getInstance]postDataWithUrl:BaseUrl(BSSDetail) parameters:dict success:^(id responseObject) {
        
        Log_ResponseObject;
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            _dataModel = [ACPBBSDetailDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            _likeBtn.selected = _dataModel.user_whether_love;
            _collectBtn.selected = _dataModel.user_whether_collection;
            [_tableView reloadData];
        }else{
          [MBProgressHUD showError:@"请求失败"];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        
    }];
}

-(void)setBottomView{
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    UIView *lineView = [UIView new];
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    lineView.backgroundColor = GlobalLightGreyColor;
  
    CGFloat btnW = (SCREENWIDTH - 40)/3;
    for(int j = 0; j < 2; j++){
        UIView *verLine = [UIView new];
        [bottomView addSubview:verLine];
        verLine.frame = CGRectMake(10 + btnW + 4 + j * (btnW + 10), 12, 2, 20);
        verLine.backgroundColor = GlobalLightGreyColor;
    }
    
    for(int i = 0;i< 3;i++){
        UIButton *btn = [UIButton new];
        [bottomView addSubview:btn];
        btn.frame = CGRectMake(10 + i *(btnW + 10), 5, btnW, 30);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        if(i == 0){
            _likeBtn = btn;
            [btn setImage:[UIImage imageNamed:@"未关注"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"关注"] forState:UIControlStateSelected];
            [btn setTitle:@"  喜欢" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 1){
            [btn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
            [btn setTitle:@"  评论" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            _collectBtn = btn;
            [btn setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];
            [btn setTitle:@"  收藏" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickCollcetBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
       
    }
    
}

-(void)loginAction{
    ACPLoginViewController *loginVC = [ACPLoginViewController new];
    loginVC.popVC = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)didClickLikeBtn:(UIButton *)sender{
    sender.enabled = NO;
    if(![ACPUserModel shareModel].isLogin){
        [self loginAction];
        sender.enabled = YES;
        return;
    }else{
        NSLog(@"%@",BaseUrl(LikePublish));
        
        NSDictionary *dict = @{
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                               @"uri":LikePublish,
                               @"paramData":@{@"user_id": [NSNumber numberWithInt: [[ACPUserModel shareModel].uid intValue]],
                                              @"community_id" : @(_Id.integerValue),
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
}

-(void)didClickCommentBtn:(UIButton *)sender{
    sender.enabled = NO;
    if(![ACPUserModel shareModel].isLogin){
        [self loginAction];
        sender.enabled = YES;
        return;
    }else{
        [[CommentManager shareManager] initWithTitle:@"" placeHolder:@"请输入评论内容" commentComplateBlock:^(UITextView *textView, UIView *markView){
            if(![textView.text isNotNil]){
                [MBProgressHUD showError:@"评论内容不能为空"];
                sender.enabled = YES;
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
                sender.enabled = YES;
                if([responseObject[@"code"] isEqualToString:@"0000"])
                {
                    [MBProgressHUD showSuccess:@"评论成功"];
                    [self getData];
                }else{
                    [MBProgressHUD showError:@"操作失败"];
                }
                [textView endEditing:YES];
            } fail:^(NSError *error) {
                sender.enabled = YES;
                [MBProgressHUD showError:@"网络错误"];
                 [textView endEditing:YES];
            }];
        } doNothingBlock:^{
            sender.enabled = YES;
        }];
    }
    
}

-(void)didClickCollcetBtn:(UIButton *)sender{
    sender.enabled = NO;
    if(![ACPUserModel shareModel].isLogin){
        [self loginAction];
        sender.enabled = YES;
        return;
    }else{
        NSLog(@"%@",BaseUrl(CollectPublish));
        
        NSDictionary *dict = @{
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                               @"uri":CollectPublish,
                               @"paramData":@{@"user_id": [NSNumber numberWithInt: [[ACPUserModel shareModel].uid intValue]],
                                              @"community_id" : @(_Id.integerValue),
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
    
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 44);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ACPCommentTableViewCell class] forCellReuseIdentifier:@"bbsCommentsCell"];
    [tableView registerClass:[ACPBBSDetailTableViewCell class] forCellReuseIdentifier:@"bbsDetailCell"];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataModel.return_message_list.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        ACPBBSDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bbsDetailCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = _dataModel;
        __weak __typeof__(cell) weakCell = cell;
        cell.didClickCollectionViewCellBlock = ^(NSInteger index){
            NSArray *cellArr = weakCell.collectionView.visibleCells;
            [self.browserImageArr removeAllObjects];;
            for(int i = 0;i < cellArr.count;i++){
                ACPBBSImageCollectionViewCell *imageCell = cellArr[i];
                [_browserImageArr addObject:imageCell.imageView.image];
            }
            NSArray *urlArr = [_dataModel.release_image_url componentsSeparatedByString:@","];
            self.browserImgUrlArr = urlArr.copy;
            SDPhotoBrowser *browser = [SDPhotoBrowser new];
            browser.sourceImagesContainerView = weakCell.collectionView;
            browser.imageCount = cellArr.count;
            browser.currentImageIndex = index;//当前需要展示图片的index
            browser.delegate = self;
            [browser show];
        };
        cell.didClickHeaderViewBlock = ^{
            ACPBBSPersonalViewController *BBSPersonalVC = [ACPBBSPersonalViewController new];
            BBSPersonalVC.userId = _userId;
            BBSPersonalVC.userImageUrl = _dataModel.user_image_url;
            BBSPersonalVC.userName = _dataModel.user_name;
//            BBSPersonalVC.introduction = _dataModel.user_brief_introduction;
            [self.navigationController pushViewController:BBSPersonalVC animated:YES];
        };
        return cell;
    }else{
        ACPCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bbsCommentsCell" forIndexPath:indexPath];
        ACPCommentDataModel *commentModel = _dataModel.return_message_list[indexPath.row - 1];
        cell.dataModel =commentModel;
//        cell.levelLabel.text = [NSString stringWithFormat:@"%zd楼",indexPath.row + 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.didClickHeaderViewBlock = ^{
            ACPCommentDataModel *dataModel = _dataModel.return_message_list[indexPath.row - 1];
            ACPBBSPersonalViewController *BBSPersonalVC = [ACPBBSPersonalViewController new];
            BBSPersonalVC.userId = dataModel.user_id;
            BBSPersonalVC.userImageUrl = dataModel.user_image_url;
            BBSPersonalVC.userName = dataModel.user_name;
//            BBSPersonalVC.introduction = dataModel.user_brief_introduction;
            [self.navigationController pushViewController:BBSPersonalVC animated:YES];
        };
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return _dataModel.rowHeight;
    }else{
        return 90;
    }
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
