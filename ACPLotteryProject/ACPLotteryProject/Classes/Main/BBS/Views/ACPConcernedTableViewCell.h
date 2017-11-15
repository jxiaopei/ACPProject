//
//  ACPConcernedTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPConcernedDataModel.h"
#import "ACPRecommendConDataModel.h"

@interface ACPConcernedTableViewCell : UITableViewCell

@property(nonatomic,strong)ACPConcernedDataModel *dataModel;
@property(nonatomic,strong)ACPRecommendConDataModel *recommendDataModel;
@property(nonatomic,strong)ACPConcernedDataModel *fansDataModel;
@property(nonatomic,copy)void(^didClickAttentionActionBtnBlock)(UIButton *sender);

@end
