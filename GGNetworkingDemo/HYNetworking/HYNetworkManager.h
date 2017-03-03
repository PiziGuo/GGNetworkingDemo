//
//  HYNetwork.h
//  HYiTong
//
//  Created by David on 2016/12/6.
//  Copyright © 2016年 com.HROCLoud. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, HYRequestType) {
    HYRequestTypeGET = 0,
    HYRequestTypePOST
};


typedef NS_ENUM(NSInteger, GGNetStatus) {
    
    GGNetStatusUnknow               = -1,
    GGNetStatusNotReachable         = 0,
    GGNetStatusReachableViaWWAN     = 1,
    GGNetStatusReachableViaWiFi     = 2
    
};


@interface HYNetworkManager : NSObject

@property (nonatomic, assign) GGNetStatus netStatus;

+ (instancetype)shareManager;


/**
 开启网络监控
 */
+ (void)startMonitoring;


/**
 获取当前网路状态
 */
+ (GGNetStatus)getNetStatus;


/**
 发送get请求 - webAPI方式创建网络请求

 @param URLString 请求的网址字符串
 @param parameters 请求的参数
 @param signArray 生成sign的数组
 @param animation 动画显示
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)GETWithURLString:(NSString *)URLString
              parameters:(id)parameters
               signArray:(NSArray *)signArray
               animation:(BOOL)animation
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

- (void)GETWithURLString:(NSString *)URLString
              parameters:(id)parameters
               signArray:(NSArray *)signArray
               animation:(BOOL)animation
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;


/**
 发送post请求 - webAPI方式创建网络请求
 
 @param URLString 请求的网址字符串
 @param parameters 请求的参数
 @param signArray 生成sign的数组
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)POSTWithURLString:(NSString *)URLString
               parameters:(id)parameters
                signArray:(NSArray *)signArray
                animation:(BOOL)animation
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

- (void)POSTWithURLString:(NSString *)URLString
               parameters:(id)parameters
                signArray:(NSArray *)signArray
                animation:(BOOL)animation
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *))failure;

/**
 发送网络请求
 
 @param URLString 请求的网址字符串
 @param parameters 请求的参数
 @param signArray 生成sign的数组
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)RequestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                   signArray:(NSArray *)signArray
                        type:(HYRequestType)type
                   animation:(BOOL)animation
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

- (void)RequestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                   signArray:(NSArray *)signArray
                        type:(HYRequestType)type
                   animation:(BOOL)animation
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *))failure;


@end
