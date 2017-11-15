//
//  ACPBBSDetailTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBBSDetailTableViewCell.h"
#import "ACPBBSImageCollectionViewCell.h"

@interface ACPBBSDetailTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *likeCount;
@property(nonatomic,strong)UILabel *commentCount;
@property(nonatomic,strong)NSArray *imageArr;

@end

@implementation ACPBBSDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        _iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(40);
        }];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 20;
        
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
        
        UIButton *headerBtn = [UIButton new];
        [self addSubview:headerBtn];
        [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_left);
            make.right.mas_equalTo(nameLabel.mas_right);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(10);
        }];
        [headerBtn addTarget:self action:@selector(didClickHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *contentLabel = [UILabel new];
        [self addSubview:contentLabel];
        _contentLabel = contentLabel;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(iconView.mas_bottom).mas_offset(10);
        }];
        contentLabel.numberOfLines = 3;
        
        UILabel *commentCount = [UILabel new];
        [self addSubview:commentCount];
        _commentCount = commentCount;
        [commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-15);
        }];
        commentCount.font = [UIFont systemFontOfSize:14];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemW = 70;
        layout.itemSize = CGSizeMake(itemW,itemW);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 2;
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 160, 230, itemW ) collectionViewLayout:layout];
        _collectionView = collectView;
        collectView.backgroundColor = [UIColor redColor];
        [self addSubview:collectView];
        collectView.delegate = self;
        collectView.dataSource = self;
        [collectView registerClass:[ACPBBSImageCollectionViewCell class] forCellWithReuseIdentifier:@"BBSImageCell"];
        collectView.backgroundColor = [UIColor whiteColor];
        collectView.showsVerticalScrollIndicator = NO;
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
        lineView.backgroundColor = GlobalLightGreyColor;
        
        UIView *titleView = [UIView new];
        [self addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(lineView.mas_top);
        }];
        
        UILabel *titleLabel = [UILabel new];
        [titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(10);
        }];
        titleLabel.text = @"全部评论";
        titleLabel.font = [UIFont systemFontOfSize:14];
        
        UIView *lineView1 = [UIView new];
        [self addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(titleLabel.mas_top);
            make.height.mas_equalTo(10);
        }];
        lineView1.backgroundColor = GlobalLightGreyColor;
        
    }
    return self;
}

-(void)didClickHeaderBtn:(UIButton *)sender{
    if(self.didClickHeaderViewBlock){
        self.didClickHeaderViewBlock();
    }
}

-(void)setDataModel:(ACPBBSDetailDataModel *)dataModel{
    _dataModel = dataModel;
    _nameLabel.text = dataModel.user_name;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(dataModel.user_image_url)] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _dateLabel.text = [dataModel.release_time insertStandardTimeFormat];
    _contentLabel.text = dataModel.release_content;
    CGSize textSize = [dataModel.release_content boundingRectWithSize:CGSizeMake(SCREENWIDTH - 20, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGFloat textHeight = textSize.height > 60 ? 60 : textSize.height;
    CGFloat collectionViewHeight = 0;
    if([dataModel.release_image_url isNotNil]){
        self.imageArr = [dataModel.release_image_url componentsSeparatedByString:@","];
        if(self.imageArr.count){
            NSUInteger row = self.imageArr.count % 3 ? self.imageArr.count / 3 + 1 : self.imageArr.count / 3;
            collectionViewHeight = row * 72;
        }
    }
    _collectionView.frame = CGRectMake(10, 80 + textHeight, 230, collectionViewHeight);
    [_collectionView reloadData];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.didClickCollectionViewCellBlock){
        self.didClickCollectionViewCellBlock(indexPath.item);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACPBBSImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BBSImageCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(self.imageArr[indexPath.item])] placeholderImage:[UIImage imageNamed:@"占位图"]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}

-(NSArray *)imageArr{
    if(_imageArr == nil){
        _imageArr = [NSArray new];
    }
    return _imageArr;
}

@end
