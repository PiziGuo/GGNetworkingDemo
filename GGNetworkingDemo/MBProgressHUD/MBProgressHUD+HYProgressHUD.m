//
//  MBProgressHUD+HYProgressHUD.m
//  HYiTong
//
//  Created by David on 2016/12/30.
//  Copyright © 2016年 com.HROCLoud. All rights reserved.
//

#import "MBProgressHUD+HYProgressHUD.h"

@implementation MBProgressHUD (HYProgressHUD)


+ (void)showMessage:(NSString *)text icon:(NSString *)iconName view:(UIView *)view hideAfter:(NSInteger)second {
    
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:second];
}


+ (void)showMessageOnlyText:(NSString *)text toView:(UIView *)view {
    
    [self showMessage:text icon:nil view:view hideAfter:2.0];
}


+ (void)showMessageText:(NSString *)text icon:(NSString *)iconName toView:(UIView *)view {
    
    [self showMessage:text icon:iconName view:view hideAfter:2.0];
}

@end
