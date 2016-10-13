//
//  CustomViewAnimation.h
//  CustomHUD
//
//  Created by WZ on 15/4/21.
//  Copyright (c) 2015年 WZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewAnimation : UIView

- (id)initWithFrame:(CGRect)frame andPicName:(NSString *)picName andLeftText:(NSString *)texts;
//旋转动画
- (void)startAnimation;
//旋转的图片名
@property (nonatomic, strong) NSString *circlePicName;
//左侧显示文字
@property (nonatomic, strong) NSString *leftText;

@end
