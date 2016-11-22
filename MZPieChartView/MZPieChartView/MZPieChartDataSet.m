//
//  MZPieChartDataSet.m
//  PieChartView
//
//  Created by MrZhao on 16/11/16.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "MZPieChartDataSet.h"
#define ZFColor(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]

@implementation MZPieChartDataSet

-(NSArray *)colorStore
{
    if (!_colorStore) {
        _colorStore = [MZPieChartDataSet colorStoreByCount:self.valueStore.count];
    }
    return _colorStore;
}

+ (NSArray *)colorStoreByCount:(NSInteger)count
{
    NSArray *moreColors =@[ZFColor(247, 79, 56, 1),ZFColor(1, 194, 251, 1),  ZFColor(28, 149, 198, 1),ZFColor(255, 202, 40, 1), ZFColor(110, 193, 149, 1),  ZFColor(90, 83, 161, 1), ZFColor(178, 110, 193, 1)];
    
    NSMutableArray *colorStore = [NSMutableArray array];
    NSInteger num = count / moreColors.count;
    NSInteger dis = count % moreColors.count;
    while (num) {
        [colorStore addObjectsFromArray:moreColors];
        num--;
    }
    if (dis == 1) {
        [colorStore addObject:moreColors[1]];
    }else{
        [colorStore addObjectsFromArray:[moreColors subarrayWithRange:NSMakeRange(0, dis)]];
    }
    
    return colorStore;
}

@end
