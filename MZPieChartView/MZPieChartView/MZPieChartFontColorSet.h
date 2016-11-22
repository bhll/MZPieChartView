//
//  MZPieChartFontColorSet.h
//  MZPieChartView
//
//  Created by MrZhao on 16/11/17.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MZPieChartFontColorSet : NSObject


/** Pie chart center text font. Default [UIFont systemFontOfSize:10.0] */

@property (nonatomic, strong) UIFont *centerTextFont;

/** Pie chart center value font. Default [UIFont systemFontOfSize:14.0] */

@property (nonatomic, strong) UIFont *centerValueFont;

/** Pie chart percent text font. Default [UIFont systemFontOfSize:15.0] */

@property (nonatomic, strong) UIFont *percentTextFont;

/** The font of the hidden percent text in the white area . Default [UIFont systemFontOfSize:15.0] */

@property (nonatomic, strong) UIFont *hiddenPercentTextFont;

/** Pie chart center text color. Default black */

@property (nonatomic, strong) UIColor *centerTextColor;

/** Pie chart center value color. Default black */

@property (nonatomic, strong) UIColor *centerValueColor;

/** The color of the percent text in the pie slice . Default white */

@property (nonatomic, strong) UIColor *percentTextColor;

/** The color of the hidden percent text in the white area . Default black */

@property (nonatomic, strong) UIColor *hiddenPercentTextColor;



@end






