//
//  ACPTextFieldCell.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/1.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTextField.h"

@interface ACPTextFieldCell : UITableViewCell

@property (nonatomic, strong) DTextField *textField;
@property (nonatomic, strong) NSString *title;

@end
