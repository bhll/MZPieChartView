//
//  MZPieChartSet.m
//  PieChartView
//
//  Created by MrZhao on 16/11/16.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "MZPieChartSet.h"

@implementation MZPieChartSet

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.valueFractionDigits = 2;
        self.startAngle = M_PI_2 * -1.0;
        self.radiusPercent = 0.24;
        self.lineWidthPercent = 0.144;
        self.selectLineWidthPercent = 0.18;
        self.hiddenPercent = 0.05;
        self.printSign = YES;
    }
    return self;
}
- (NSString *)piechartValueFormat
{
    NSString *str = [NSString stringWithFormat:@"%%.%luf",self.valueFractionDigits];
    return str;
}
@end
