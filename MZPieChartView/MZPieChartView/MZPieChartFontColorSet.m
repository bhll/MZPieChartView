//
//  MZPieChartFontColorSet.m
//  MZPieChartView
//
//  Created by MrZhao on 16/11/17.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "MZPieChartFontColorSet.h"

@implementation MZPieChartFontColorSet

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.centerTextFont = [UIFont systemFontOfSize:10.0];
        self.centerValueFont = [UIFont systemFontOfSize:14.0];
        self.percentTextFont = [UIFont systemFontOfSize:15.0];
        self.centerTextColor = [UIColor blackColor];
        self.centerValueColor = [UIColor blackColor];
        self.percentTextColor = [UIColor whiteColor];
        self.hiddenPercentTextColor = [UIColor blackColor];
    }
    return self;
}

@end
