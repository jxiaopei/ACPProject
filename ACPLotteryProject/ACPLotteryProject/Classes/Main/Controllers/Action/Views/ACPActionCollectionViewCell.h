//
//  ACPActionCollectionViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPActionDataModel.h"

@interface ACPActionCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)ACPActionDataModel *dataModel;
@property(nonatomic,strong)UIImageView *iconView;

@end
