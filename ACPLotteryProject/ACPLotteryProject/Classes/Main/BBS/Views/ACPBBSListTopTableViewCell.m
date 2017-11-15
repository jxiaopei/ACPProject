//
//  ACPBBSListTopTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/25.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPBBSListTopTableViewCell.h"

@interface ACPBBSListTopTableViewCell()

@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *likeCount;
@property(nonatomic,strong)UILabel *commentCount;
@property(nonatomic,strong)NSArray *imageArr;

@end

@implementation ACPBBSListTopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        _iconView = iconView;
        iconView.frame = CGRectMake(SCREENWIDTH - 10 - SCREENWIDTH * 2 /5, 10, SCREENWIDTH * 2 /5, 120);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickHeaderIconView:)];
        [iconView addGestureRecognizer:tap];
        iconView.userInteractionEnabled = YES;
        
        UILabel *contentLabel = [UILabel new];
        [self addSubview:contentLabel];
        _contentLabel = contentLabel;
//        contentLabel.frame = CGRectMake(10, 10, SCREENWIDTH * 3 / 5 - 25, 90);
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(iconView.mas_left).mas_offset(-5);
        }];
        contentLabel.numberOfLines = 4;
        
        UIButton *isTopBtn = [UIButton new];
        [self addSubview:isTopBtn];
        [isTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(20);
        }];
        isTopBtn.layer.borderWidth = 1;
        [isTopBtn setTitle:@"置顶" forState:UIControlStateNormal];
        [isTopBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        isTopBtn.layer.masksToBounds = YES;
        isTopBtn.layer.cornerRadius = 5;
        isTopBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        UILabel *commentCount = [UILabel new];
        [self addSubview:commentCount];
        _commentCount = commentCount;
        [commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(iconView.mas_left).mas_offset(-5);
            make.bottom.mas_equalTo(-15);
        }];
        commentCount.font = [UIFont systemFontOfSize:14];
        
        UIImageView *commentImage = [UIImageView new];
        [self addSubview:commentImage];
        [commentImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(commentCount.mas_left).mas_offset(-5);
            make.bottom.mas_equalTo(-15);
            make.width.height.mas_equalTo(15);
        }];
        commentImage.image = [UIImage imageNamed:@"评论"];
        
        UILabel *likeCount = [UILabel new];
        [self addSubview:likeCount];
        _likeCount = likeCount;
        [likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(commentImage.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(-15);
        }];
        likeCount.font = [UIFont systemFontOfSize:14];
        
        UIImageView *likeImage = [UIImageView new];
        [self addSubview:likeImage];
        [likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(likeCount.mas_left).mas_offset(-5);
            make.bottom.mas_equalTo(-15);
            make.width.height.mas_equalTo(15);
        }];
        likeImage.image = [UIImage imageNamed:@"未关注"];
        
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

-(void)didClickHeaderIconView:(UITapGestureRecognizer *)tap{
    if(self.didClickHeaderViewBlock){
        self.didClickHeaderViewBlock();
    }
}

-(void)setDataModel:(ACPBBSListDataModel *)dataModel{
    _dataModel = dataModel;
    _contentLabel.text = dataModel.release_content;
    if([dataModel.release_image_url isNotNil]){
        self.imageArr = [dataModel.release_image_url componentsSeparatedByString:@","];
        if(self.imageArr.count){
            [_iconView sd_setImageWithURL:[NSURL URLWithString:BaseUrl(self.imageArr[0])] placeholderImage:[UIImage imageNamed:@"占位图"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                CGFloat imageW =  image.size.height/120 * image.size.width;
                imageW = imageW >= SCREENWIDTH * 2 / 5 ? SCREENWIDTH * 2 / 5 : imageW;
                _iconView.frame =  CGRectMake(SCREENWIDTH - 10 - imageW,10 , imageW, 120);
            }];
        }
    }
    _likeCount.text = dataModel.love_count;
    _commentCount.text = dataModel.return_message_count;
   
}

-(NSArray *)imageArr{
    if(_imageArr == nil){
        _imageArr = [NSArray new];
    }
    return _imageArr;
}


@end
