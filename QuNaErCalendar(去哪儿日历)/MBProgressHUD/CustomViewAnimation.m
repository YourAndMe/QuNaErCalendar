//
//  CustomViewAnimation.m
//  CustomHUD
//
//  Created by WZ on 15/4/21.
//  Copyright (c) 2015年 WZ. All rights reserved.
//

#import "CustomViewAnimation.h"

@interface CustomViewAnimation ()

@property (nonatomic, strong) CALayer *circleLayer;

@end

@implementation CustomViewAnimation

- (id)initWithFrame:(CGRect)frame andPicName:(NSString *)picName andLeftText:(NSString *)texts
{
    self = [super initWithFrame:frame];
    if (self) {
        self.circlePicName = picName;
        self.leftText = texts;
        [self makeLayer];
        [self makeScr];
    }
    return self;
}

-(void)makeLayer
{
    //创建一个layer
    _circleLayer=[CALayer layer];
    //设置layer的属性
    _circleLayer.bounds=CGRectMake(0, 0, 30, 30);
    _circleLayer.position=CGPointMake(19.5, 25);
    
    //设置需要显示的图片
    _circleLayer.contents=(id)[UIImage imageNamed:self.circlePicName].CGImage;
    
    //把layer添加到界面上
    [self.layer addSublayer:_circleLayer];
}

-(void)makeScr
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(43, 5, 80, 40)];
    lab.text = self.leftText;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    lab.font = [UIFont systemFontOfSize:14];
    [self addSubview:lab];
}
#pragma mark - Animation

- (void)startAnimation
{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.duration = 1;
    
    animation.repeatCount       = MAXFLOAT;
    animation.fromValue         = [NSNumber numberWithDouble:0];
    animation.toValue           = [NSNumber numberWithDouble:M_PI*2];
    [_circleLayer addAnimation:animation forKey:nil];
}

@end
