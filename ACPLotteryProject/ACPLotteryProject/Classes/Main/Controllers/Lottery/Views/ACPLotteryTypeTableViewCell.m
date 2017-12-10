//
//  ACPLotteryTypeTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/24.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPLotteryTypeTableViewCell.h"
#import "ACPLotteryDataCollectionViewCell.h"
@import WebKit;

@interface ACPLotteryTypeTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,assign)NSInteger indexNumber;
@property(nonatomic,strong)NSArray *stateArr;

@end

@implementation ACPLotteryTypeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(countSecondsAction) name:@"countSecond" object:nil];
        
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        _iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(50);
        }];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 25;
        
        UILabel *nameLabel = [UILabel new];
        [self addSubview:nameLabel];
        _nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
            make.top.mas_equalTo(10);
        }];
        nameLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
            make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(5);
        }];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textColor = [UIColor grayColor];
        
        UILabel *stateLabel = [UILabel new];
        [self addSubview:stateLabel];
        _stateLabel = stateLabel;
        [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        stateLabel.font = [UIFont systemFontOfSize:14];
        
        _stateArr = @[@"正在开奖",@"正在开奖.",@"正在开奖..",@"正在开奖...",@"正在开奖...."];
        _indexNumber = 0;

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemW = (SCREENWIDTH - 85)/10;
        layout.itemSize = CGSizeMake(itemW,itemW);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 2;
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 80, SCREENWIDTH - 40, itemW) collectionViewLayout:layout];
        _collectionView = collectView;
        collectView.backgroundColor = [UIColor redColor];
        [self addSubview:collectView];
        collectView.delegate = self;
        collectView.dataSource = self;
        [collectView registerClass:[ACPLotteryDataCollectionViewCell class] forCellWithReuseIdentifier:@"lotteryDataCell"];
        collectView.backgroundColor = [UIColor whiteColor];
        collectView.showsVerticalScrollIndicator = NO;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 60, SCREENWIDTH - 40, itemW + 30)];
        _webView.userInteractionEnabled = NO;
        NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"donga" ofType:@"gif"]];
        [_webView loadData:gif MIMEType:@"image/gif" characterEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
        [self addSubview:_webView];
        _webView.hidden = YES;
        
        UIView *bottomView = [UIView new];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-5);
            make.height.mas_equalTo(40);
        }];
        
        CGFloat btnW = (SCREENWIDTH - 40)/3;
        for(int i = 0;i< 3;i++){
            UIButton *btn = [UIButton new];
            [bottomView addSubview:btn];
            btn.frame = CGRectMake(10 + i *(btnW + 10), 5, btnW, 30);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            if(i == 0){
                [btn setImage:[UIImage imageNamed:@"all_type_01"] forState:UIControlStateNormal];
                [btn setTitle:@"  历史开奖" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didClickHistroyBtn:) forControlEvents:UIControlEventTouchUpInside];
            }else if (i == 1){
                [btn setImage:[UIImage imageNamed:@"all_type_02"] forState:UIControlStateNormal];
                [btn setTitle:@"  走势图表" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didClickTrendBtn:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [btn setImage:[UIImage imageNamed:@"all_type_03"] forState:UIControlStateNormal];
                [btn setTitle:@"  讨论" forState:UIControlStateNormal];
//                [btn addTarget:self action:@selector(didClickDiscutionBtn:) forControlEvents:UIControlEventTouchUpInside];
                btn.hidden = YES;
            }
            
        }
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
        lineView.backgroundColor = GlobalLightGreyColor;
        
    }
    return self;
}

-(void)didClickHistroyBtn:(UIButton *)sender{
    if(self.didClickHistroyBtnBlock){
        self.didClickHistroyBtnBlock();
    }
}

-(void)didClickTrendBtn:(UIButton *)sender{
    if(self.didClickTrendBtnBlock){
        self.didClickTrendBtnBlock();
    }
}

-(void)countSecondsAction{
    if(_dataModel.lottery_next_time > 0){
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"下期开奖:%@",[_dataModel timeString]]];
        [str addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5, [_dataModel timeString].length)];
        self.stateLabel.attributedText = str;
        _webView.hidden = YES;
    }else{
        NSString *state = _stateArr[_indexNumber];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:state];
        [str addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0,state.length)];
        self.stateLabel.attributedText = str;
        if(_indexNumber > 3){
            _indexNumber = 0;
        }else{
            _indexNumber ++;
        }
        _webView.hidden = NO;
    }
}

-(void)setDataModel:(ACPLotteryListModel *)dataModel{
    _dataModel = dataModel;
    _nameLabel.text = dataModel.lottery_name;
    _dateLabel.text = [NSString stringWithFormat:@"已开%@期",dataModel.lottery_nper];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(dataModel.lottery_image_url)] placeholderImage:[UIImage imageNamed:@"占位图"]];
    CGFloat itemW = (SCREENWIDTH - 85)/10;
    if([dataModel.lottery_name isEqualToString:@"北京快乐8"]){
        _collectionView.frame = CGRectMake(10, 80, SCREENWIDTH - 40, itemW * 2 + 3);
        _webView.frame = CGRectMake(10, 60, SCREENWIDTH - 40, itemW * 2 + 3 + 30);
//        [_webView.scrollView setContentOffset:CGPointMake(0, 25)];
    }else{
        _collectionView.frame = CGRectMake(10, 80, SCREENWIDTH - 40, itemW);
        _webView.frame = CGRectMake(10, 60, SCREENWIDTH - 40, itemW + 30);
//        [_webView.scrollView setContentOffset:CGPointMake(0, 25)];
    }
    [_collectionView reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.didClickCollectionViewCellBlock){
        self.didClickCollectionViewCellBlock();
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACPLotteryDataModel *dataModel = self.dataModel.lottery_result[indexPath.item];
    ACPLotteryDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lotteryDataCell" forIndexPath:indexPath];
    if([self.dataModel.lottery_name isEqualToString:@"北京快乐8"]){
        cell.imageView.hidden = YES;
        cell.titleLabel.hidden = NO;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@,",dataModel.text];
        if(dataModel.text.integerValue > 40){
            cell.titleLabel.textColor = GlobalRedColor;
        }else{
            cell.titleLabel.textColor = GlobalSkyBlueColor;
        }
        
    }else{
        cell.imageView.hidden = NO;
        cell.titleLabel.hidden = YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dataModel.back_ground] placeholderImage:[UIImage imageNamed:@"占位图"]];
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataModel.lottery_result.count;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
