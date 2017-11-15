//
//  ACPMsgSwitchTableViewCell.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPMsgSwitchTableViewCell.h"

@interface ACPMsgSwitchTableViewCell ()

@property(nonatomic,strong)UISwitch *msgSwitch;

@end

@implementation ACPMsgSwitchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
        }];
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        UISwitch *msgSwitch = [UISwitch new];
        [self addSubview:msgSwitch];
        _msgSwitch = msgSwitch;
        [msgSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
        }];
        
    }
    return self;
}

-(void)setIsSwitchOn:(BOOL)isSwitchOn{
    _isSwitchOn = isSwitchOn;
    _msgSwitch.on = isSwitchOn;
}


@end
