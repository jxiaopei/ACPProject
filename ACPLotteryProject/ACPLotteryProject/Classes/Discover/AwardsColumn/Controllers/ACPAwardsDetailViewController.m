//
//  ACPAwardsDetailViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/13.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPAwardsDetailViewController.h"

@interface ACPAwardsDetailViewController ()

@property(nonatomic,assign)CGFloat imgH;

@end

@implementation ACPAwardsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    [self customTitleWith:_titleStr];
    [self setupUI];
}

-(void)setupUI{
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    UILabel *titleLab = [UILabel new];
    [scrollView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREENWIDTH-30);
        make.top.mas_equalTo(10);
    }];
    titleLab.font = [UIFont systemFontOfSize:22];
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *dateLab = [UILabel new];
    [scrollView addSubview:dateLab];
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(SCREENWIDTH-15);
        make.top.mas_equalTo(titleLab.mas_bottom).mas_offset(5);
    }];
    dateLab.textAlignment = NSTextAlignmentRight;
    dateLab.font = [UIFont systemFontOfSize:13];
    dateLab.textColor = [UIColor grayColor];
    
    UIView *line = [UIView new];
    [scrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.top.mas_equalTo(dateLab.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = .3;
    
    UIImageView *imageView = [UIImageView new];
    [scrollView addSubview:imageView];
    imageView.frame = CGRectMake(0, 65, SCREENWIDTH, 0);
    _imgH = 0;
    
    UITextView *textView = [UITextView new];
    [scrollView addSubview:textView];
    textView.frame = CGRectMake(5, 65, SCREENWIDTH-10, SCREENHEIGHT - 60 - 64);
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor darkGrayColor];
//    textView.text= @"我在这里";
    textView.userInteractionEnabled = NO;
    
    NSLog(@"%@",BaseUrl(AwardsDetail));
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":AwardsDetail,
                           @"paramData":@{
                                   @"id" :_awardID}
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(AwardsDetail) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            NSString *imageUrl = responseObject[@"data"][@"data_content"][0][@"picture_link"];
            if(imageUrl){
                NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:responseObject[@"data"][@"data_content"][0][@"picture_link"]]];
                UIImage *image = [UIImage imageWithData:imageData];
                CGSize imageSize = image.size;
                _imgH = imageSize.height >0? imageSize.height * SCREENWIDTH / imageSize.width : 0;
                imageView.frame = CGRectMake(0, 65, SCREENWIDTH, _imgH);
                imageView.image = image;
            }
            
            titleLab.text = responseObject[@"data"][@"data_content"][0][@"skill_title"];
            dateLab.text = responseObject[@"data"][@"data_content"][0][@"platform_name"];
            NSString *content = responseObject[@"data"][@"data_content"][0][@"skill_content"];
            CGSize textSize = [content boundingRectWithSize:CGSizeMake(SCREENWIDTH - 10, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
            textView.text = content;
            CGFloat textHeight = textSize.height < 60 ? 60 : textSize.height;
            textView.frame = CGRectMake(5, 65 + _imgH, SCREENWIDTH-10, textHeight);
            [scrollView setContentSize:CGSizeMake(SCREENWIDTH, _imgH + textHeight)];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

@end
