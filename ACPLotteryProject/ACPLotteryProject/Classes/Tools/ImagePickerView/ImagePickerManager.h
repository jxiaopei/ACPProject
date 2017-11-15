//
//  ImagePickerManager.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/11/8.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^imagePickComplateBlock)(NSString *imagePath);

@interface ImagePickerManager : NSObject

+(instancetype)shareManager;

-(void)initImagePickerViewAndHandleTheImagePathBlock:(imagePickComplateBlock)handleBlock;

@end
