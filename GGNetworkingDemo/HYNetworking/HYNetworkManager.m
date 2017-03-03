//
//  HYNetwork.m
//  HYiTong
//
//  Created by David on 2016/12/6.
//  Copyright © 2016年 com.HROCLoud. All rights reserved.
//

#import "HYNetworkManager.h"
#import "AFNetworking.h"
//
//lib
#import "MBProgressHUD.h"

static NSMutableArray *tasks;// 保存网络请求任务的数组

@implementation HYNetworkManager


NSString * GetSignStringFromSignArray(NSArray *signArray);
NSString * GetTimeStringFromDate(NSDate *date);
NSDictionary *GenerateParamstersDictionaryWithSignArray(NSArray *signArray, NSDictionary *clientDict);


/**
 创建单例
 控制动画显示
 @return 单例
 */
+ (instancetype)shareManager {
    static HYNetworkManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}




/**
 开启网络监控
 仅仅是封装了一下AFN的
 */
+ (void)startMonitoring {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    // 网络状态有改变 会调用这个block
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [HYNetworkManager shareManager].netStatus = GGNetStatusUnknow;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [HYNetworkManager shareManager].netStatus = GGNetStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [HYNetworkManager shareManager].netStatus = GGNetStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [HYNetworkManager shareManager].netStatus = GGNetStatusReachableViaWiFi;
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}
/**
 获取当前网路状态
 */
+ (GGNetStatus)getNetStatus {
    
    [self startMonitoring];
    
    GGNetStatus netStatus = [HYNetworkManager shareManager].netStatus;
    
    switch (netStatus) {
        case GGNetStatusReachableViaWiFi:
            return GGNetStatusReachableViaWiFi;
            break;
        case GGNetStatusReachableViaWWAN:
            return GGNetStatusReachableViaWWAN;
            break;
        case GGNetStatusNotReachable:
            return GGNetStatusNotReachable;
            break;
        case GGNetStatusUnknow:
            return GGNetStatusUnknow;
            break;
        default:
            break;
    }
}

/**
 保存网络任务的数组，暂时不需要
 */
+ (NSMutableArray *)tasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

/**
 获取AFNHTTPSessionManager实例
 */
+ (AFHTTPSessionManager *)getAFHTTPSessionManager {
    
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        // 可以接受返回数据的类型（json）
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.requestSerializer.timeoutInterval = 30;
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithArray:@[
                                                                                 @"application/json",
                                                                                 @"text/html",
                                                                                 @"text/json",
                                                                                 @"text/plain",
                                                                                 @"text/javascript",
                                                                                 @"text/xml",
                                                                                 @"image/*"
                                                                                 ]];
        
        
    });
    return manager;
}


/**
 AFHTTPResponseSerializer 
 AFJSONResponseSerializer
 两者区别：确定写AFJSONResponseSerializer AFN默认会将接收到的json数据解析好，在成功的回调就不用解析了
        用AFHTTPResponseSerializer AFN接收的是NSData数据，并不会给解析，需要在成功的回调自己解析。
 */
- (AFHTTPSessionManager *)getAFHTTPSessionManager {
    
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        // 可以接受返回数据的类型（json）
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.requestSerializer.timeoutInterval = 30;
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithArray:@[
                                                                                 @"application/json",
                                                                                 @"text/html",
                                                                                 @"text/json",
                                                                                 @"text/plain",
                                                                                 @"text/javascript",
                                                                                 @"text/xml",
                                                                                 @"image/*"
                                                                                 ]];
        
        
    });
    return manager;
}

#pragma mark - GET
+ (void)GETWithURLString:(NSString *)URLString
              parameters:(id)parameters
               signArray:(NSArray *)signArray
               animation:(BOOL)animation
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure{
    
    NSString *interface = [WEB_BASE_URL stringByAppendingString:URLString];
    NSLog(@"请求的最终链接---》%@",interface);
    if (animation) {
        // 在这里设置加载动画，可自定义
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    NSDictionary *parametersDictionary = GenerateParamstersDictionaryWithSignArray(signArray, parameters);
    
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManager];
    [manager GET:interface parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            if (animation) {
                
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
            // 这里根据创建AFHTTPSessionManager的对返回数据的解析器来写的，
            //NSError *error;
            //id responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (animation) {
               [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
            failure(error);
        }
    }];
    
}





- (void)GETWithURLString:(NSString *)URLString
              parameters:(id)parameters
               signArray:(NSArray *)signArray
               animation:(BOOL)animation
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *error))failure {
    
    NSString *interface = [WEB_BASE_URL stringByAppendingString:URLString];
    if (animation) {
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    NSDictionary *parametersDictionary = GenerateParamstersDictionaryWithSignArray(signArray, parameters);
    
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManager];
    [manager GET:interface parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (animation) {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (animation) {
               [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
            failure(error);
        }
    }];
    
}


#pragma mark - POST
+ (void)POSTWithURLString:(NSString *)URLString
               parameters:(id)parameters
                signArray:(NSArray *)signArray
                animation:(BOOL)animation
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    
    NSString *interface = [WEB_BASE_URL stringByAppendingString:URLString];
    NSLog(@"POST  interface ---> %@",interface);
    NSDictionary *paramsDict = GenerateParamstersDictionaryWithSignArray(signArray, parameters);
    if (animation) {
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManager];
    [manager POST:interface parameters:paramsDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (animation) {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
            //
            //NSError *error;
            //id responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (animation) {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
            failure(error);
        }
    }];
}

- (void)POSTWithURLString:(NSString *)URLString
               parameters:(id)parameters
                signArray:(NSArray *)signArray
                animation:(BOOL)animation
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
    
    NSString *interface = [WEB_BASE_URL stringByAppendingString:URLString];
    NSLog(@"POST interface---> %@",interface);
    NSDictionary *paramsDict = GenerateParamstersDictionaryWithSignArray(signArray, parameters);
    if (animation) {
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManager];
    [manager POST:interface parameters:paramsDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (animation) {
               [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
            //NSError *error;
            //id responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (animation) {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
            failure(error);
        }
    }];
}


+ (void)RequestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                   signArray:(NSArray *)signArray
                        type:(HYRequestType)type
                   animation:(BOOL)animation
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString *interface = [WEB_BASE_URL stringByAppendingString:URLString];
    NSLog(@"Request Type--> %lu URL---> %@",(unsigned long)type,interface);
    NSDictionary *parametersDictionary = GenerateParamstersDictionaryWithSignArray(signArray, parameters);
    if (animation) {
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManager];
    
    switch (type) {
        case HYRequestTypeGET:
        {
            [manager GET:interface parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    if (animation) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    }
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    if (animation) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    }
                    failure(error);
                }
            }];
        }
            break;
            
        case HYRequestTypePOST:
        {
            [manager POST:interface parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    if (animation) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    }
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    if (animation) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    }
                    failure(error);
                }
            }];
            
        }
            break;
    }
    
}


- (void)RequestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                   signArray:(NSArray *)signArray
                        type:(HYRequestType)type
                   animation:(BOOL)animation
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {
    
    NSString *interface = [WEB_BASE_URL stringByAppendingString:URLString];
    NSLog(@"Request Type--> %lu URL---> %@",(unsigned long)type,interface);
    NSDictionary *parametersDictionary = GenerateParamstersDictionaryWithSignArray(signArray, parameters);
    if (animation) {
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    AFHTTPSessionManager *manager = [self getAFHTTPSessionManager];
    switch (type) {
        case HYRequestTypeGET:
        {
            [manager GET:interface parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    if (animation) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    }
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    if (animation) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    }
                    failure(error);
                }
            }];
        }
            break;
            
        case HYRequestTypePOST:
        {
            [manager POST:interface parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    if (animation) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    }
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    if (animation) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    }
                    failure(error);
                }
            }];
            
        }
            break;
    }
    
}


#pragma mark - private method
/**
 获取时间戳

 @param date <#date description#>
 @return <#return value description#>
 */
NSString * GetTimeStringFromDate(NSDate *date){
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSString * dateString = [format stringFromDate:date];
    
    return dateString;
}

/**
 获取sign值

 @param signArray <#signArray description#>
 @return <#return value description#>
 */
NSString * GetSignStringFromSignArray(NSArray *signArray){
    
    NSString *signStr = [@"kc123456ts" mutableCopy];
    NSDate *date = [NSDate date];
    NSString *timeStr = GetTimeStringFromDate(date);
    signStr = [signStr stringByAppendingString:timeStr];
    // 根据array获取sign
    NSMutableString *signString = [@"" mutableCopy];
    for (int i = 0; i < signArray.count; i++) {
        if (i != 0) {
            [signString appendString:@""];
        }
        NSString *tmpStr = [NSString stringWithFormat:@"%@",signArray[i]];
        [signString appendString:tmpStr];
    }
    signStr = [signStr stringByAppendingString:signString];
    signStr = [signStr stringByAppendingString:@"kc123456"];
    signStr = [signStr AX_md5];
    signStr = [signStr uppercaseString];
    NSLog(@"signStr------>%@",signString);
    return signStr;
    
}

/**
 生成参数字典
 
 @param signArray <#signArray description#>
 @param clientDict <#clientDict description#>
 @return <#return value description#>
 */
+ (NSDictionary *)generateParamstersDictionaryWithSignArray:(NSArray *)signArray andClientDictionary:(NSDictionary *)clientDict{
    
    NSDictionary *parametersDictionary = [NSDictionary dictionary];
    if (clientDict == nil) {
        parametersDictionary = clientDict;
        return parametersDictionary;
    } else {
        // 获取时间戳
        NSDate *date = [NSDate date];
        NSString *timeStr = GetTimeStringFromDate(date);
        // 封装一个方法，获取sign
        NSString *signStr = GetSignStringFromSignArray(signArray);
        NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
        if (dictParams) {
            [dictParams addEntriesFromDictionary:clientDict];
        }
        [dictParams addEntriesFromDictionary:dictParams];
        [dictParams addEntriesFromDictionary:@{@"sign":signStr}];
        [dictParams addEntriesFromDictionary:@{@"ts":timeStr}];
        parametersDictionary = dictParams;
        return parametersDictionary;
    }
}

NSDictionary *GenerateParamstersDictionaryWithSignArray(NSArray *signArray, NSDictionary *clientDict) {
    
    NSDictionary *parametersDictionary = [NSDictionary dictionary];
    if (clientDict == nil) {
        parametersDictionary = clientDict;
        return parametersDictionary;
    } else {
        // 获取时间戳
        NSDate *date = [NSDate date];
        NSString *timeStr = GetTimeStringFromDate(date);
        // 封装一个方法，获取sign
        NSString *signStr = GetSignStringFromSignArray(signArray);
        NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
        if (dictParams) {
            [dictParams addEntriesFromDictionary:clientDict];
        }
        [dictParams addEntriesFromDictionary:dictParams];
        [dictParams addEntriesFromDictionary:@{@"sign":signStr}];
        [dictParams addEntriesFromDictionary:@{@"ts":timeStr}];
        parametersDictionary = dictParams;
        return parametersDictionary;
    }
}


@end
