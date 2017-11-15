//
//  ACPNewClassDetailViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/17.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPNewClassDetailViewController.h"

@interface ACPNewClassDetailViewController ()

@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)NSMutableArray *dataSourse;
@property(nonatomic,strong)NSMutableArray *officialDataSourse;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIView *underLineView;
@property(nonatomic,strong)NSMutableArray *imageViewArr;
@property(nonatomic,strong)UILabel *statusLabel;
@property(nonatomic,assign)BOOL isStausInit;

@end

@implementation ACPNewClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourse = [[_urlString componentsSeparatedByString:@","] copy];
    _officialDataSourse = [[_officialUrlString componentsSeparatedByString:@","] copy];
    [self customBackBtn];
    [self setupScrollView];
    [self setupTitleView];
    [self getData];
}

-(void)setupScrollView{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    _scrollview = scrollView;
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, 800);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    _scrollview.mj_header = header;
}

-(void)setupTitleView{
    UIView *titleView = [UIView new];
    [self.scrollview addSubview:titleView];
    titleView.backgroundColor = [UIColor whiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(45);
    }];
    
    UIView *lineView = [UIView new];
    [titleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(0.5);
    }];
    lineView.backgroundColor = GlobalLightGreyColor;
    
    NSArray *titleArr = @[@"官方玩法",@"信用玩法"];
    for(int i = 0; i < titleArr.count;i++){
        UIButton *titleBtn = [UIButton new];
        [titleView addSubview:titleBtn];
        CGFloat margant = 20;
        titleBtn.frame = CGRectMake(((SCREENWIDTH -  margant) /2 + margant) * i,5, (SCREENWIDTH - margant) /2, 35);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(didClickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            titleBtn.selected = YES;
            _selectedBtn = titleBtn;
            
            UIView *underLineView = [UIView new];
            [titleView addSubview:underLineView];
            _underLineView = underLineView;
            underLineView.frame = CGRectMake(0, 40, (SCREENWIDTH -  margant) /2, 3);
            underLineView.backgroundColor = GlobalRedColor;
        }
    }
    
}

-(void)didClickTitleBtn:(UIButton *)sender{
    
    if([sender.titleLabel.text isEqualToString:_selectedBtn.titleLabel.text]){
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat margant = 20;
        _underLineView.frame = CGRectMake(((SCREENWIDTH -  margant) /2 + margant) *(sender.tag) , 40, (SCREENWIDTH - margant) /2, 3);
    }];
    sender.selected = YES;
    _selectedBtn.selected = NO;
    _selectedBtn = sender;
    [_scrollview.mj_header beginRefreshing];
}

-(void)getData{
    if(self.imageViewArr.count){
        for(int i = 0;i <self.imageViewArr.count;i++){
            [self.imageViewArr[i] removeFromSuperview];
        }
    }
    CGFloat height = 0;

    if(_selectedBtn.tag){
        if(_dataSourse.count && ![_dataSourse[0]isEqualToString:@""]){
            if(_isStausInit){
                [_statusLabel removeFromSuperview];
                _isStausInit = NO;
            }
            for(int i = 0;i < _dataSourse.count;i++){
                UIImageView *imageView = [UIImageView new];
                [_scrollview addSubview:imageView];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_dataSourse[i]]];
                UIImage *image = [UIImage imageWithData:imageData];
                CGSize imageSize = image.size;
                CGFloat imgH = imageSize.height >0? imageSize.height * SCREENWIDTH / imageSize.width : 0;
                imageView.image = image;
                imageView.frame = CGRectMake(0, 45 + height, SCREENWIDTH, imgH);
                height += imgH;
                [self.imageViewArr addObject:imageView];
            }
        }else{
            [self initStatus];
        }
    }else{
        if(_officialDataSourse.count && ![_officialDataSourse[0]isEqualToString:@""]){
            if(_isStausInit){
                [_statusLabel removeFromSuperview];
                _isStausInit = NO;
            }
            for(int i = 0;i < _officialDataSourse.count;i++){
                UIImageView *imageView = [UIImageView new];
                [_scrollview addSubview:imageView];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_officialDataSourse[i]]];
                UIImage *image = [UIImage imageWithData:imageData];
                CGSize imageSize = image.size;
                CGFloat imgH = imageSize.height >0? imageSize.height * SCREENWIDTH / imageSize.width : 0;
                imageView.image = image;
                imageView.frame = CGRectMake(0, 45 + height, SCREENWIDTH, imgH);
                height += imgH;
                [self.imageViewArr addObject:imageView];
            }
        }else{
            [self initStatus];
        }
    }
    _scrollview.contentSize = CGSizeMake(SCREENWIDTH, 45 + height);
    [_scrollview.mj_header endRefreshing];
}

-(void)initStatus{
    UILabel *statueLabel = [UILabel new];
    [self.view addSubview:statueLabel];
    statueLabel.text = @"暂无该玩法";
    [statueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.left.mas_equalTo(SCREENWIDTH/2 - 100);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(SCREENHEIGHT/2 - 15);
    }];
    statueLabel.font = [UIFont systemFontOfSize:15];
    statueLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel = statueLabel;
    _isStausInit = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([_titleStr isNotNil]){
        [self customTitleWith:_titleStr];
    }
    
}

-(NSMutableArray *)imageViewArr{
    if(_imageViewArr == nil){
        _imageViewArr = [NSMutableArray new];
    }
    return _imageViewArr;
}

@end
