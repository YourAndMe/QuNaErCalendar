//
//  MBProgressHUD+XZ.h
//
//  Created by XZ on 13-4-18.
//  Copyright (c) 2013年 mekor. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (XZ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;


/**
 *  添加时间的
 */
+ (void)showSuccess:(NSString *)success withTime:(NSTimeInterval)time;
+ (void)showError:(NSString *)error withTime:(NSTimeInterval)time;
+ (void)showText:(NSString *)text withTime:(NSTimeInterval)time withYOffset:(float)yOffsets;
+ (void)showText:(NSString *)text withTime:(NSTimeInterval)time;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
+(void)hide;
@end
