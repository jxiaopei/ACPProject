//
//  ACPLoginTextFieldCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTextField.h"

@interface ACPLoginTextFieldCell : UITableViewCell

@property (nonatomic, strong) DTextField *textField;
@property (nonatomic, strong) NSDictionary *dict;

@end
