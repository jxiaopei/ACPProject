//
//  LCTextFieldCell.h
//  LotteryClient
//
//  Created by Dick on 2017/7/3.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTextField.h"

@interface LCTextFieldCell : UITableViewCell

@property (nonatomic, strong) DTextField *textField;
@property (nonatomic, strong) NSDictionary *dict;

@end
