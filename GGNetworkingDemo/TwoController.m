//
//  TwoController.m
//  GGNetworkingDemo
//
//  Created by David on 2017/1/17.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import "TwoController.h"

@interface TwoController ()

@end

@implementation TwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self netForGetProductList];
    
    [HYNetworkManager getNetStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 webAPI的方式请求热品数据
 */
- (void)netForGetProductList {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setValue:[NSString stringWithFormat:@"%@",@"1"] forKey:@"Page"];
    [jsonDict setValue:[NSString stringWithFormat:@"%d",10] forKey:@"PageSize"];
    [jsonDict setValue:@"" forKey:@"SearchWords"];
    [jsonDict setValue:@"0" forKey:@"CityCode"];
    [jsonDict setValue:@"0" forKey:@"BrandCode"];
    [jsonDict setValue:@"0" forKey:@"CountryCode"];
    [jsonDict setValue:@"0" forKey:@"GoodsCategory"];
    [jsonDict setValue:@"A4E2" forKey:@"MemberID"];
    [jsonDict setValue:@"" forKey:@"ActivityID"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSArray *signArr = @[@"searchCondition",jsonStr];
    NSDictionary *paramDict = @{
                                @"searchCondition":jsonStr,
                                };
    
    NSString *urlStr = @"Product/GetProductList";
    
    HYNetworkManager *manager = [HYNetworkManager shareManager];
    [manager GETWithURLString:urlStr parameters:paramDict signArray:signArr animation:YES success:^(id response) {
        NSLog(@"获取热品列表----->%@",response);
    } failure:^(NSError *error) {
        NSLog(@"请求失败%@",error);
    }];
    
//    [HYNetworkManager GETWithURLString:urlStr parameters:paramDict signArray:signArr success:^(id responseObject) {
//        
//        NSLog(@"获取热品列表----->%@",responseObject);
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"请求失败%@",error);
//    }];
    
}


@end
