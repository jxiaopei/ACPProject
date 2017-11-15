//
//  ACPBaseNetworkServiceTool.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPBaseNetworkServiceTool : NSObject

+(ACPBaseNetworkServiceTool *)shareServiceTool;

-(void)setNetWorkService;

-(void)getAppBaseInfors;

-(void)getUpdateInfor;

-(void)httpDNSAction;

@end
