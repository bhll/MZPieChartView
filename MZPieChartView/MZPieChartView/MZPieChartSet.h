//
//  MZPieChartSet.h
//  PieChartView
//
//  Created by MrZhao on 16/11/16.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MZPieChartSet : NSObject


/** The number of digits after the decimal.
 
 Default is 2 */

@property (nonatomic, assign) NSUInteger valueFractionDigits;

/** The start angle of pie chart. 
 
 Default is M_PI_2*(-1.0) */

@property (nonatomic, assign) CGFloat startAngle;

/** The radius of the piechart in percent of the maximum radius(MZPieChartView.width , MZPieChartView.height)).
 
 Defalut is 0.24 */

@property (nonatomic, assign) CGFloat radiusPercent;

/**  The width of a pie slice in percent of the maximum radius (max = min(MZPieChartView.width , MZPieChartView.height)). 
 
  Default is 0.144 */

@property (nonatomic, assign) CGFloat lineWidthPercent;


/**  The selection width of a pie slice in percent of the maximum radius (max = min(MZPieChartView.width , MZPieChartView.height)).
 
    Default is 0.18 */

@property (nonatomic, assign) CGFloat selectLineWidthPercent;

/** When the percent of a pie slice < hiddenPercent，do not show the percent text of the pie slice.
 
 Default is 0.05*/

@property (nonatomic, assign) CGFloat hiddenPercent;

/** Print Sign */

@property (nonatomic, assign) BOOL printSign;

/** return [NSString stringWithFormat:@"%%.%luf",self.valueFractionDigits]
 
 if self.valueFractionDigits = 2, return %.2f
 
 Default return %.2f */

- (NSString *)piechartValueFormat;



@end
