//
//  WZCCalendarDayCell.h
//  QuNaErCalendar(去哪儿日历)
//
//  Created by wziMAC on 16/10/12.
//  Copyright © 2016年 WZC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZCCalendarDayModel.h"
#import "Color.h"

@interface WZCCalendarDayCell : UICollectionViewCell
{
    UILabel *day_lab;//今天的日期或者是节日
    UILabel *day_title;//显示标签
    
}

@property(nonatomic , strong)WZCCalendarDayModel *model;
@property(nonatomic , strong)UIImageView *imgview;//选中时的图片
@property(nonatomic , assign)NSInteger imageTag;//选中时的图片显示类型：0：蓝色  1：红色
@end
