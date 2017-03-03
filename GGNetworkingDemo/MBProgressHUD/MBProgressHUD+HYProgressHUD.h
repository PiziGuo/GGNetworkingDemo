//
//  MBProgressHUD+HYProgressHUD.h
//  HYiTong
//
//  Created by David on 2016/12/30.
//  Copyright © 2016年 com.HROCLoud. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (HYProgressHUD)



/**
 显示提示的View

 @param text <#text description#>
 @param iconName <#iconName description#>
 @param view <#view description#>
 @param second <#second description#>
 */
+ (void)showMessage:(NSString *)text icon:(NSString *)iconName view:(UIView *)view hideAfter:(NSInteger)second;


/**
 展示文字消息  两秒后消失

 @param text <#text description#>
 @param view <#view description#>
 */
+ (void)showMessageOnlyText:(NSString *)text toView:(UIView *)view;



/**
 同时展示文字和图片信息 两秒后消失

 @param text <#text description#>
 @param iconName <#iconName description#>
 @param view <#view description#>
 */
+ (void)showMessageText:(NSString *)text icon:(NSString *)iconName toView:(UIView *)view;

@end
