//
//  ACPLotteryListTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPLotteryListTableViewCell.h"
#import "ACPLotteryDataCollectionViewCell.h"

@interface ACPLotteryListTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UILabel *lotteryLabel;
@property(nonatomic,strong)UILabel *periodLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *detailView;

@end

@implementation ACPLotteryListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *lotteryLabel = [UILabel new];
        [self addSubview:lotteryLabel];
        _lotteryLabel = lotteryLabel;
        [lotteryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
        lotteryLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *periodLabel = [UILabel new];
        [self addSubview:periodLabel];
        _periodLabel = periodLabel;
        [periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lotteryLabel.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(lotteryLabel.mas_centerY);
        }];
        periodLabel.font = [UIFont systemFontOfSize:13];
        periodLabel.textColor = [UIColor grayColor];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(periodLabel.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(lotteryLabel.mas_centerY);
        }];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [UIColor grayColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemW = (SCREENWIDTH - 85)/10;
        layout.itemSize = CGSizeMake(itemW,itemW);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 2;
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 40, SCREENWIDTH - 40, itemW * 2 + 3) collectionViewLayout:layout];
        _collectionView = collectView;
        collectView.backgroundColor = [UIColor redColor];
        [self addSubview:collectView];
        collectView.delegate = self;
        collectView.dataSource = self;
        [collectView registerClass:[ACPLotteryDataCollectionViewCell class] forCellWithReuseIdentifier:@"lotteryDataCell"];
        collectView.backgroundColor = [UIColor whiteColor];
        collectView.showsVerticalScrollIndicator = NO;
        
        UIView *detailView = [UIView new];
        [self addSubview:detailView];
        _detailView = detailView;
        [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-25);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(itemW);
        }];
        
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

-(void)setDataModel:(ACPLotteryListModel *)dataModel{
    _dataModel =dataModel;
    _lotteryLabel.text = dataModel.lottery_name;
    _periodLabel.text = [NSString stringWithFormat:@"第%@期",dataModel.lottery_nper];
    NSString *dateStr = [dataModel.create_time substringToIndex:8];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateStr = [dateFormat stringFromDate:date];
    NSString *totolStr = [NSString stringWithFormat:@"%@(%@)",newDateStr,[self weekdayStringFromDate:date]];
    _dateLabel.text =  totolStr;
    CGFloat itemW = (SCREENWIDTH - 85)/10;
    if([dataModel.lottery_name isEqualToString:@"北京快乐8"]){
        _collectionView.frame = CGRectMake(15, 40, SCREENWIDTH - 40, itemW * 2 + 3);
    }else{
        _collectionView.frame = CGRectMake(15, 40, SCREENWIDTH - 40, itemW);
    }
    [_collectionView reloadData];
    if(_detailView.subviews.count){
        for(UIView *subView in _detailView.subviews){
            [subView removeFromSuperview];
        }
    }

    if([dataModel.lottery_extra_0 isNotNil]){
        NSArray *detailArr = [dataModel.lottery_extra_0 componentsSeparatedByString:@","];
        for(int i = 0;i < detailArr.count; i++){
            UILabel *detailLabel = [UILabel new];
            [_detailView addSubview:detailLabel];
            detailLabel.frame = CGRectMake((itemW + 5) * i, 0, itemW +3, itemW);
            detailLabel.font = [UIFont systemFontOfSize:12];
            detailLabel.backgroundColor = [UIColor grayColor];
            detailLabel.layer.masksToBounds = YES;
            detailLabel.layer.cornerRadius = 5;
            detailLabel.text = detailArr[i];
            detailLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
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


@end
