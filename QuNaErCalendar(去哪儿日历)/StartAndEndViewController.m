//
//  StartAndEndViewController.m
//  QuNaErCalendar(去哪儿日历)
//
//  Created by wziMAC on 16/10/12.
//  Copyright © 2016年 WZC. All rights reserved.
//

#import "StartAndEndViewController.h"
//UI
#import "WZCCalendarMonthCollectionViewLayout.h"
#import "WZCCalendarMonthHeaderView.h"
#import "WZCCalendarDayCell.h"
//MODEL
#import "WZCCalendarDayModel.h"


@interface StartAndEndViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    NSTimer* timer;//定时器
    WZCCalendarDayModel *modelTemp;//记录结束日期
}

@property(nonatomic ,strong) UILabel *startLab;//选中的日期
@property(nonatomic ,strong) UILabel *endLab;//选中的日期
@end

@implementation StartAndEndViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.selectDaysArr.count==2) {
        WZCCalendarDayModel *modelFirsts = self.selectDaysArr[1];
        modelTemp = modelFirsts;
    }
    [self initData];
    [self initView];
    self.calendarMonth = [self getMonthArrayOfDayNumber:self.day ToDateforString:nil];
    NSMutableArray *tempArr1 = self.calendarMonth[0];
    for (int i=0; i<tempArr1.count; i++) {
        WZCCalendarDayModel *model = self.calendarMonth[0][i];
        if (model.style == CellDayTypeClick) {
            [self.Logic selectLogic:model];
            break;
        }
    }
    [self.collectionView reloadData];//刷新
    
}

- (void)initView{
    
    [self setTitle:@"选择日期"];
    
    WZCCalendarMonthCollectionViewLayout *layout = [WZCCalendarMonthCollectionViewLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout]; //初始化网格视图大小
    [self.collectionView registerClass:[WZCCalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    [self.collectionView registerClass:[WZCCalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    self.collectionView.delegate = self;//实现网格视图的delegate
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self makeSignView];
}

-(void)initData{
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
}

#pragma mark CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
    return monthArray.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WZCCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    
    WZCCalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    int i=0;
    NSString *currentStr = [model toString];
    for (; i<self.selectDaysArr.count; i++) {
        WZCCalendarDayModel *oraginModel = self.selectDaysArr[i];
        NSString *oraginStr = [oraginModel toString];
        if ([oraginStr isEqualToString:currentStr]) {
            if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek) {
                [self.Logic selectLogic:model];
                [self.selectDaysArr removeObject:oraginModel];
                [self.selectDaysArr addObject:model];
            }else if (model.style == CellDayTypeClick){
                [self.selectDaysArr removeObject:oraginModel];
                [self.selectDaysArr addObject:model];
            }
            break;
        }
    }
    if ([[modelTemp toString] isEqualToString:currentStr]) {
        cell.imageTag = 1;
    }
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        WZCCalendarDayModel *model = [month_Array objectAtIndex:15];
        
        WZCCalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%d年 %d月",model.year,model.month];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
        reusableview = monthHeader;
    }
    return reusableview;
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectDaysArr.count==2) {
        WZCCalendarDayModel *modelFirsts = self.selectDaysArr[0];
        WZCCalendarDayModel *modelFirsts1 = self.selectDaysArr[1];
        [self.Logic selectLogic:modelFirsts];
        [self.Logic selectLogic:modelFirsts1];
        [self.selectDaysArr removeAllObjects];
        modelTemp = nil;
        [self.collectionView reloadData];
    }
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    WZCCalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    
    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek) {
        if (self.selectDaysArr.count==0) {
            [self.Logic selectLogic:model];
            [self.selectDaysArr addObject:model];
            [self.collectionView reloadData];
            [UIView animateWithDuration:0.5 animations:^{
                self.endLab.hidden = NO;
                self.startLab.frame = CGRectMake(320, 500, 200, 44);
                self.endLab.frame = CGRectMake(60, 500, 200, 44);
            } completion:^(BOOL finished) {
                self.startLab.hidden = YES;
            }];
        }else if (self.selectDaysArr.count==1){
            BOOL bigs = [self selectDateIsBigThanFirstDate:model];
            if (bigs) {
                [self.Logic selectLogic:model];
                [self.selectDaysArr addObject:model];
                modelTemp = model;
                [self.collectionView reloadData];
            }else{
                WZCCalendarDayModel *modelFirsts = self.selectDaysArr[0];
                [self.Logic selectLogic:modelFirsts];
                [self.selectDaysArr removeAllObjects];
                
                [self.Logic selectLogic:model];
                [self.selectDaysArr addObject:model];
                [self.collectionView reloadData];
            }
        }
        
    }else if (model.style == CellDayTypeClick) {
        BOOL bigs = [self selectDateIsBigThanFirstDate:model];
        if (bigs) {
            [self.Logic selectLogic:model];
            [self.selectDaysArr addObject:model];
            [self.collectionView reloadData];
        }
    }
    
    if (self.selectDaysArr.count==2) {
        if (self.calendarblock) {
            
            self.calendarblock(self.selectDaysArr);//传递数组给上级
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        }
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)selectDateIsBigThanFirstDate:(WZCCalendarDayModel *)model
{
    WZCCalendarDayModel *modelFirst = self.selectDaysArr[0];
    if (model.year==modelFirst.year) {
        if (model.month==modelFirst.month) {
            if (model.day>=modelFirst.day) {
                return YES;
            }
        }else if (model.month>modelFirst.month){
            return YES;
        }
    }else if (model.year>modelFirst.year){
        return YES;
    }
    return NO;
}


//定时器方法
- (void)onTimer{
    [timer invalidate];//定时器无效
    timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 底部提示
-(void)makeSignView
{
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(-320, 500, 200, 44)];
    endLabel.backgroundColor = [UIColor blackColor];
    endLabel.alpha = 0.5;
    endLabel.hidden = YES;
    endLabel.text = @"请输入结束时间";
    endLabel.textColor = [UIColor whiteColor];
    endLabel.font = [UIFont systemFontOfSize:18];
    endLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:endLabel];
    self.endLab = endLabel;
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 500, 200, 44)];
    startLabel.backgroundColor = [UIColor blackColor];
    startLabel.alpha = 0.5;
    startLabel.text = @"请输入开始时间";
    startLabel.textColor = [UIColor whiteColor];
    startLabel.font = [UIFont systemFontOfSize:18];
    startLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:startLabel];
    self.startLab = startLabel;
}

#pragma mark 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    NSDate *selectdate  = [NSDate date];
    if (todate) {
        selectdate = [selectdate dateFromString:todate];
    }
    self.Logic = [[WZCCalendarLogic alloc]init];
    return [self.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end