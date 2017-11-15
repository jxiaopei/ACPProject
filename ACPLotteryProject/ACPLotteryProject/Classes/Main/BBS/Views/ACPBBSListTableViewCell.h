//
//  ACPBBSListTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPBBSListDataModel.h"

@interface ACPBBSListTableViewCell : UITableViewCell

@property(nonatomic,strong)ACPBBSListDataModel *dataModel;
@property(nonatomic,copy)void(^didClickCollectionViewCellBlock)(NSInteger index);
@property(nonatomic,copy)void(^didClickHeaderViewBlock)();
@property(nonatomic,strong)UICollectionView *collectionView;

@end
