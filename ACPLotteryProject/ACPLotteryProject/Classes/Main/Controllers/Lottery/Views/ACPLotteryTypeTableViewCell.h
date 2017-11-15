//
//  ACPLotteryTypeTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/24.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPLotteryListModel.h"

@interface ACPLotteryTypeTableViewCell : UITableViewCell

@property(nonatomic,strong)ACPLotteryListModel *dataModel;
@property(nonatomic,copy)void(^didClickCollectionViewCellBlock)();
@property(nonatomic,copy)void(^didClickHistroyBtnBlock)();
@property(nonatomic,copy)void(^didClickTrendBtnBlock)();

@end
