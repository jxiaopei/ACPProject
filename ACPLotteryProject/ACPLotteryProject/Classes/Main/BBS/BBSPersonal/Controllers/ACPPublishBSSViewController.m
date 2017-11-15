//
//  ACPPublishBSSViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPPublishBSSViewController.h"
#import "MKComposePhotosView.h"
#import "MKMessagePhotoView.h"

@interface ACPPublishBSSViewController ()<UITextViewDelegate,UIScrollViewDelegate,MKMessagePhotoViewDelegate>

@property(nonatomic,strong)UILabel *placeholder;
@property(nonatomic,strong)UITextView *contentText;
@property(nonatomic,strong)UIButton *publishBtn;
@property (nonatomic, strong) MKMessagePhotoView *photosView;
@property (nonatomic,strong) NSMutableArray *imagePath;

@end

@implementation ACPPublishBSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:@"发布新帖"];
    [self setupUI];
    [self setUpPhotosView];
}

#pragma mark -相册视图
-(void)setUpPhotosView
{
    if (!self.photosView){
        self.photosView = [[MKMessagePhotoView alloc]initWithFrame:CGRectMake(0,140,SCREENWIDTH, 40 + 10 + 3 *(SCREENWIDTH - 20 - 15)/4)];
        [self.view addSubview:self.photosView];
        _imagePath = self.photosView.imagePath;
        self.photosView.delegate = self;
    }
}

//实现代理方法
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)addUIImagePicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}

- (void)didSelectePhotoMenuItem:(MKComposePhotosView *)shareMenuItem atIndex:(NSInteger)index{
    NSLog(@"点击图片");
}

-(void)setupUI{
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    scrollView.delegate = self;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [scrollView setContentSize:CGSizeMake(SCREENWIDTH, SCREENHEIGHT - 64 + 10)];
    
    UILabel *titleLabel = [UILabel new];
    [scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(50);
    }];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"标题:";
    
    UIButton *publishBtn = [UIButton new];
    [scrollView addSubview:publishBtn];
    _publishBtn = publishBtn;
    publishBtn.frame = CGRectMake(0, SCREENHEIGHT - 50 - 64, SCREENWIDTH, 50);
    publishBtn.backgroundColor = GlobalRedColor;
    [publishBtn setTitle:@"发 布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [publishBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *textView = [UITextView new];
    [scrollView addSubview:textView];
    _contentText = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREENWIDTH-20);
        make.height.mas_equalTo(140);
    }];
    textView.delegate =self;
    textView.font = [UIFont systemFontOfSize:18];
    
    _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, 200, 20)];
    _placeholder.enabled = NO;
    _placeholder.text = @"请输入内容";
    _placeholder.font =  [UIFont systemFontOfSize:18];
    _placeholder.textColor = [UIColor lightGrayColor];
    [textView addSubview:_placeholder];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.photosView.frame = CGRectMake(0,140 - offsetY,SCREENWIDTH, 40 + 10 + 3 *(SCREENWIDTH - 20 - 15)/4);
    _publishBtn.frame = CGRectMake(0, SCREENHEIGHT - 50 - 64 + offsetY, SCREENWIDTH, 50);
}

-(void)didClickPublishBtn:(UIButton *)sender
{
    NSMutableArray *imgArr = [NSMutableArray array];
    if(_imagePath.count){
        for (NSString *imagePath in _imagePath) {
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            NSString *baseStr =  [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [imgArr addObject:baseStr];
        }
    }
    NSLog(@"%@",BaseUrl(AddPublish));
    NSDictionary *dict = nil;
    if(imgArr.count){
        dict =  @{
                  @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                  @"uri":AddPublish,
                  @"paramData":@{@"user_id": [NSNumber numberWithInt: [[ACPUserModel shareModel].uid intValue]],
                                 @"release_image" : imgArr,
                                 @"release_content": _contentText.text,
                                 },
                  };
    }else{
        dict = @{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":AddPublish,
                 @"paramData":@{@"user_id": [NSNumber numberWithInt: [[ACPUserModel shareModel].uid intValue]],
                                @"release_content": _contentText.text,
                                },
                 };
    }
    [[ACPNetworkTool getInstance] postImageDataToServiceWithUrl:BaseUrl(AddPublish) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"发布成功成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"操作失败"];
        }
      
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
       
    }];
    
}

- (void) textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        
        [_placeholder setHidden:NO];
        
    }else{
        [_placeholder setHidden:YES];
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_contentText endEditing:YES];
}

@end
