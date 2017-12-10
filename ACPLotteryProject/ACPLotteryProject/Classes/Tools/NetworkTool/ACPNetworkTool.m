//
//  ACPNetworkTool.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/9/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPNetworkTool.h"
#import "LCNetDataParsing.h"

@implementation ACPNetworkTool

+ (ACPNetworkTool *)getInstance{
    static ACPNetworkTool *netRequest = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netRequest = [[self alloc] init];
    });
    return netRequest;
}

- (AFHTTPSessionManager *)sharedManager{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        //这里进行设置；
        [manager setSecurityPolicy:securityPolicy];
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript",nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20;
    });
    return manager;
}

- (AFHTTPSessionManager *)sharedJsonManager{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:nil];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript",nil];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer  = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20;
    });
    return manager;
}

- (AFHTTPSessionManager *)sharedImageManager{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:nil];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20;
    });
    return manager;
}

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
                  fail:(NetRequestFailedBlock)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 15;
    
    NSMutableDictionary *baseParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    NSMutableString *url = [urlString mutableCopy];
    //    [self resetURL:url Parameters:baseParameters];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (success) {
            success(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        //        [Helper showTip:error.localizedDescription];
        
        if (fail) {
            fail(error);
        }
    }];
}


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
                   fail:(NetRequestFailedBlock)fail
{
    AFHTTPSessionManager *manager =  [self sharedJsonManager];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {
            fail(error);
        }
    }];
}

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
                       fail:(NetRequestFailedBlock)fail
{

    AFHTTPSessionManager *manager = [self sharedManager];
    [manager POST:urlString parameters:[LCNetDataParsing inputParsing:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([LCNetDataParsing outputParsing:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {
            fail(error);
        }
    }];
}

-(void)postImageDataWithUrl:(NSString *)urlString parameters:(id)parameters success:(NetRequestSuccessBlock)success fail:(NetRequestFailedBlock)fail
{
    
    AFHTTPSessionManager *manager = [self sharedManager];
    [manager POST:urlString parameters:[LCNetDataParsing inputParsing:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success([LCNetDataParsing outputImageParsing:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {
            fail(error);
        }
    }];
    
}

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
                                 fail:(NetRequestFailedBlock)fail{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(error);
            });
        }else{
            if (!data || ![data isKindOfClass:[NSData class]] || data == nil) {
                return ;
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success([LCNetDataParsing outputParsing:data]);
                });
            }
        }
        
    }];
    [dataTask resume];
    
}


@end
