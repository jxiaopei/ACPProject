//
//  ACPNewsListTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPNewsListTableViewCell.h"

@interface ACPNewsListTableViewCell ()

@property(nonatomic,strong)UILabel *newsTitle;
@property(nonatomic,strong)UITextView *newsDetail;
@property(nonatomic,strong)UIImageView *newsImage;
@property(nonatomic,strong)UILabel *publishLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextView *detailText;
@property(nonatomic,strong)UILabel *dateLabel;

@end

@implementation ACPNewsListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *newsTitle = [UILabel new];
        [self addSubview:newsTitle];
        _newsTitle = newsTitle;
        [newsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-15);
        }];
        newsTitle.adjustsFontSizeToFitWidth = YES;
        newsTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        newsTitle.textColor = [UIColor blackColor];
        newsTitle.text = @"菲律宾新闻";
        
        UILabel *publishLabel = [UILabel new];
        [self addSubview:publishLabel];
        _publishLabel = publishLabel;
        [publishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-20);
        }];
        publishLabel.font = [UIFont systemFontOfSize:13];
        publishLabel.textColor = [UIColor grayColor];
        
        UITextView  *newsDetail = [UITextView new];
        [self addSubview:newsDetail];
        _newsDetail = newsDetail;
        [newsDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(newsTitle);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(publishLabel.mas_top).mas_offset(-15);
            make.top.mas_equalTo(newsTitle.mas_bottom).mas_offset(10);
        }];
        newsDetail.font = [UIFont systemFontOfSize:14];
        newsDetail.textColor = [UIColor grayColor];
        newsDetail.text = @"新闻内容";
        newsDetail.editable = NO;
        newsDetail.userInteractionEnabled = NO;
        
        UIImageView *newsImage = [UIImageView new];
        [self addSubview:newsImage];
        _newsImage = newsImage;
        [newsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(SCREENWIDTH/2);
            make.height.mas_equalTo(100);
            make.top.mas_equalTo(10);
        }];
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(newsImage.mas_right).mas_offset(5);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        titleLabel.textColor = [UIColor blackColor];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo( -10);
            make.bottom.mas_equalTo(-10);
            make.left.mas_equalTo(newsImage.mas_right).mas_offset(5);
        }];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:13];
        
        UITextView *detailText = [UITextView new];
        [self addSubview:detailText];
        _detailText = detailText;
        [detailText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(newsImage.mas_right).mas_offset(5);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(5);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(dateLabel.mas_top).mas_offset(-10);
        }];
        detailText.font = [UIFont systemFontOfSize:14];
        detailText.textColor = [UIColor grayColor];
        detailText.editable = NO;
        detailText.userInteractionEnabled = NO;
        
        
        UIView *horView = [UIView new];
        [self addSubview:horView];
        [horView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
        horView.backgroundColor = GlobalLightGreyColor;
        
        
    }
    return self;
}

-(void)setDataModel:(ACPNewsListDataModel *)dataModel
{
    _dataModel = dataModel;
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithData:[dataModel.data_content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute :NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    if([dataModel.pictures_link isNotNil]){
        _newsImage.hidden = NO;
        _titleLabel.hidden = NO;
        _detailText.hidden = NO;
        _dateLabel.hidden = NO;
        _newsTitle.hidden = YES;
        _newsDetail.hidden = YES;
        _publishLabel.hidden = YES;
        [_newsImage sd_setImageWithURL:[NSURL URLWithString:dataModel.pictures_link] placeholderImage:[UIImage imageNamed:@"占位图"]];
        _titleLabel.text = dataModel.news_title;
        _detailText.attributedText = attributeStr;
        _dateLabel.text = [dataModel.create_time insertStandardTimeFormat];
    }else{
        _newsImage.hidden = YES;
        _titleLabel.hidden = YES;
        _detailText.hidden = YES;
        _dateLabel.hidden = YES;
        _newsTitle.hidden = NO;
        _newsDetail.hidden = NO;
        _publishLabel.hidden = NO;
        _newsTitle.text = dataModel.news_title;
        _newsDetail.attributedText = attributeStr;
        _publishLabel.text = [dataModel.create_time insertStandardTimeFormat];
    }
    
}

@end
