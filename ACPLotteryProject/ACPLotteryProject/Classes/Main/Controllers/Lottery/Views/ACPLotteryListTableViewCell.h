//
//  ACPLotteryListTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/14.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPLotteryListModel.h"

@interface ACPLotteryListTableViewCell : UITableViewCell

@property(nonatomic,strong)ACPLotteryListModel *dataModel;
@property(nonatomic,copy)void(^didClickCollectionViewCellBlock)();

@end
