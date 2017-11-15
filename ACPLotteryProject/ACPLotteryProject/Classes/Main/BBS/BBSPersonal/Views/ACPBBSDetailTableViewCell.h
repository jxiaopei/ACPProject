//
//  ACPBBSDetailTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPBBSDetailDataModel.h"

@interface ACPBBSDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)ACPBBSDetailDataModel *dataModel;
@property(nonatomic,copy)void(^didClickCollectionViewCellBlock)(NSInteger index);
@property(nonatomic,copy)void(^didClickHeaderViewBlock)();
@property(nonatomic,strong)UICollectionView *collectionView;

@end
