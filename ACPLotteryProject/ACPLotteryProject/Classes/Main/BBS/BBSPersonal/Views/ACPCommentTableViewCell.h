//
//  ACPCommentTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPCommentDataModel.h"

@interface ACPCommentTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *levelLabel;
@property(nonatomic,strong)ACPCommentDataModel *dataModel;
@property(nonatomic,copy)void(^didClickHeaderViewBlock)();

@end
