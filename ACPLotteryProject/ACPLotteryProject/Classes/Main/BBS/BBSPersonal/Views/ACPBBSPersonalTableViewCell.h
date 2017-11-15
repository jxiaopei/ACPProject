//
//  ACPBBSPersonalTableViewCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/20.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPBBSListDataModel.h"

@interface ACPBBSPersonalTableViewCell : UITableViewCell

@property(nonatomic,strong)ACPBBSListDataModel *dataModel;
@property(nonatomic,copy)void(^didClickCollectionViewCellBlock)(NSInteger index);
@property(nonatomic,copy)void(^didClickHeaderViewBlock)();
@property(nonatomic,copy)void(^didClickLikeBtnBlock)(UIButton *sender);
@property(nonatomic,copy)void(^didClickCommentBtnBlock)();
@property(nonatomic,copy)void(^didClickCollectBtnBlock)(UIButton *sender);
@property(nonatomic,copy)void(^didClickDelectBtnBlock)(UIButton *sender);
@property(nonatomic,strong)UICollectionView *collectionView;


@end
