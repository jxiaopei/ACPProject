//
//  ACPBBSListTopTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/25.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPBBSListDataModel.h"

@interface ACPBBSListTopTableViewCell : UITableViewCell

@property(nonatomic,strong)ACPBBSListDataModel *dataModel;
@property(nonatomic,copy)void(^didClickHeaderViewBlock)();
@property(nonatomic,strong)UIImageView *iconView;

@end
