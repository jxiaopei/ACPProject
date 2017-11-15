//
//  ACPNetworkTool.h
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetRequestSuccessBlock)(id responseObject);//成功Block
typedef void (^NetRequestFailedBlock)(NSError *error);//失败Block

@interface ACPNetworkTool : NSObject

/**
 *  单例
 */
+(ACPNetworkTool *)getInstance;

- (AFHTTPSessionManager *)sharedManager;

/**
 *  Get形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)getJsonWithUrl:(NSString *)urlString
            parameters:(id)parameters
               success:(NetRequestSuccessBlock)success
                  fail:(NetRequestFailedBlock)fail;

/**
 *  Post形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)postJsonWithUrl:(NSString *)urlString
             parameters:(id)parameters
                success:(NetRequestSuccessBlock)success
                   fail:(NetRequestFailedBlock)fail;

/**
 *  Post形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)postDataWithUrl:(NSString *)urlString
                 parameters:(id)parameters
                    success:(NetRequestSuccessBlock)success
                       fail:(NetRequestFailedBlock)fail;

/**
 *  Post形式提交数据(拦截接口数据用)
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)postImageDataWithUrl:(NSString *)urlString
             parameters:(id)parameters
                success:(NetRequestSuccessBlock)success
                   fail:(NetRequestFailedBlock)fail;

/**
 *  Post形式提交图片数据(拦截接口数据用)
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)postImageDataToServiceWithUrl:(NSString *)urlString
                  parameters:(id)parameters
                     success:(NetRequestSuccessBlock)success
                        fail:(NetRequestFailedBlock)fail;

@end
